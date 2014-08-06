#!/usr/bin/python
from selenium import webdriver
import unittest

class TestMultiUserAutomation(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Chrome()
        self.driver.get("http://localhost:3000")
        for handle in self.driver.window_handles:
            self.original_window_handle = handle
        self.driver.execute_script("window.open('http://localhost:3000', '_blank');")
        self.driver.execute_script("window.open('http://localhost:3000', '_blank');")

    def tearDown(self):
        for handle in self.driver.window_handles:
            if handle != self.original_window_handle:
                self.driver.switch_to_window(handle)
                self.driver.execute_script("window.close();")
        self.driver.switch_to_window(self.original_window_handle)
        self.driver.close()

    def test_title_basic(self):
        assert len(self.driver.window_handles) == 3
        for handle in self.driver.window_handles:
            self.driver.switch_to_window(handle)
            assert "MOOCChat" in self.driver.title

if __name__ == '__main__':
    unittest.main()
