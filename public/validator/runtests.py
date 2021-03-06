from subprocess import Popen, PIPE
import unittest
from appclienttest import msg

class Test(unittest.TestCase):
    def _parse(self, output):
        parsed = [tuple(l.split(" ", 1)[0].split(":")) for l in  output.splitlines()]
        parsed = [(code, getattr(msg, message)) for code, message in parsed]
        msg_count = {}
        for code, message in parsed:
            msg_count[code] = msg_count.get(code, 0) + 1
            
        return (parsed, msg_count)
        
    def testNonWellFormed(self):
        """
        Non-WellFormed output should be caught
        and a log message recording the malformed
        XML should be produced.
        """
        output = Popen(["python", "./validator/appclienttest.py", "--quiet", "--playback=./validator/rawtestdata/invalid-service/"], stdout=PIPE).communicate()[0]
        parsed, msg_count = self._parse(output)
        self.assertTrue(("Error", msg.WELL_FORMED_XML) in parsed)
        self.assertEqual(1, msg_count["Begin_Test"])
        self.assertEqual(0, msg_count.get("Warning", 0))

    def testComplete(self):
        """
        Test a complete path through the flow. The following errors
        have been injected into a good run:

        The service document does not return Etag or Last-Modified headers.
        On Entry creation neither a Location or Content-Location: header are returned.
        The Slug header is ignored.
        The Entry does not contain an 'edit' link.
        The PUT to update the entry fails with a 400.
        The XML returned from creating a media entry is not well-formed.
        """
        output = Popen(["python", "./validator/appclienttest.py", "--quiet", "--playback=./validator/rawtestdata/complete/"], stdout=PIPE).communicate()[0]
        parsed, msg_count = self._parse(output)
        self.assertTrue(("Warning", msg.HTTP_ETAG) in parsed)
        self.assertTrue(("Warning", msg.HTTP_LAST_MODIFIED) in parsed)        
        self.assertTrue(("Error", msg.CREATE_RETURNS_LOCATION) in parsed)        
        self.assertTrue(("Warning", msg.CREATE_CONTENT_LOCATION) in parsed)        
        self.assertTrue(("Warning", msg.SLUG_HEADER) in parsed)        
        self.assertTrue(("Warning", msg.ENTRY_LINK_EDIT) in parsed)        
        self.assertTrue(("Error", msg.PUT_STATUS_CODE) in parsed)        
        self.assertTrue(("Error", msg.WELL_FORMED_XML) in parsed)




        


if __name__ == "__main__":
    unittest.main()
    
