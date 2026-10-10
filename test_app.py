import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parent

class WebsiteTests(unittest.TestCase):
    def test_homepage_exists(self):
        self.assertTrue((ROOT / "index.html").is_file())

    def test_homepage_has_html(self):
        content = (ROOT / "index.html").read_text(encoding="utf-8")
        self.assertIn("<html", content.lower())

    def test_health_file_exists(self):
        self.assertTrue((ROOT / "health.html").is_file())

    def test_nginx_configuration_exists(self):
        self.assertTrue((ROOT / "nginx.conf").is_file())

if __name__ == "__main__":
    unittest.main()
