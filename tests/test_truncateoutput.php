<?php
//
// After including cdash_test_case.php, subsequent require_once calls are
// relative to the top of the CDash source tree
//
require_once(dirname(__FILE__).'/cdash_test_case.php');
require_once('cdash/common.php');
require_once('cdash/pdo.php');

class TruncateOutputTestCase extends KWWebTestCase
{
    public function __construct()
    {
        parent::__construct();
        $this->ConfigFile = dirname(__FILE__)."/../cdash/config.local.php";
        $this->ConfigLine = '$CDASH_LARGE_TEXT_LIMIT = \'29\';
';
        $this->Expected = "CDash truncated output because it exceeded 29 characters.\n...\nThis part survives truncation\n";
        $this->BuildId = 0;
    }

    public function testTruncateOutput()
    {
        // Set a limit so long output will be truncated.
        $this->modifyConfig();

        // Submit our testing data.
        $rep  = dirname(__FILE__)."/data/TruncateOutput";
        if (!$this->submission('InsightExample', "$rep/Build.xml")) {
            $this->fail("failed to submit Build.xml");
            $this->cleanup();
            return 1;
        }

        // Query for the ID of the build that we just created.
        $buildid_results = pdo_single_row_query(
            "SELECT id FROM build WHERE name='TruncateOutput'");
        $this->BuildId = $buildid_results['id'];

        // Verify that the output was properly truncated.
        $this->get($this->url . "/api/v1/viewBuildError.php?buildid=" . $this->BuildId);
        $content = $this->getBrowser()->getContent();
        $jsonobj = json_decode($content, true);
        foreach ($jsonobj['errors'] as $error) {
            if ($error['stdoutput'] != $this->Expected) {
                $this->fail("Expected $this->Expected, found " . $error['stdoutput']);
                $this->cleanup();
                return 1;
            }
            if ($error['stderror'] != $this->Expected) {
                $this->fail("Expected $this->Expected, found " . $error['stderror']);
                $this->cleanup();
                return 1;
            }
        }

        $this->cleanup();
        $this->pass("Passed");
        return 0;
    }

    public function modifyConfig()
    {
        $contents = file_get_contents($this->ConfigFile);
        $handle = fopen($this->ConfigFile, "w");
        $lines = explode("\n", $contents);
        foreach ($lines as $line) {
            if (strpos($line, "?>") !== false) {
                fwrite($handle, $this->ConfigLine);
            }
            if ($line != '') {
                fwrite($handle, "$line\n");
            }
        }
        fclose($handle);
    }

    public function restoreConfig()
    {
        $contents = file_get_contents($this->ConfigFile);
        $contents = str_replace($this->ConfigFile, '', $contents);
        file_put_contents($this->ConfigFile, $contents);
    }

    public function cleanup()
    {
        // Restore our configuration and delete the build that we created.
        $this->restoreConfig();
        if ($this->BuildId > 0) {
            remove_build($this->BuildId);
        }
    }
}
