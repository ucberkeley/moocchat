#!/usr/bin/python
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
import unittest

class TestMultiUserAutomation(unittest.TestCase):
    def setUp(self):
        self.group_size = 3
        self.driver = webdriver.Chrome()
        driver = self.driver
        driver.get("http://localhost:3000")
        for handle in driver.window_handles:
            self.original_window_handle = handle
        for i in range(self.group_size - 1):
            driver.execute_script("window.open('http://localhost:3000', '_blank');")

    def tearDown(self):
        driver = self.driver
        for handle in driver.window_handles:
            if handle != self.original_window_handle:
                driver.switch_to_window(handle)
                driver.execute_script("window.close();")
        driver.switch_to_window(self.original_window_handle)
        driver.close()

    def test_title_basic(self):
        driver = self.driver
        assert len(driver.window_handles) == self.group_size
        for handle in driver.window_handles:
            driver.switch_to_window(handle)
            assert "MOOCChat" in driver.title

    def test_group_reaches_first_task_page(self):
        driver = self.driver
        for i in range(len(driver.window_handles)):
            handle = driver.window_handles[i]
            driver.switch_to_window(handle)

            # Fill in initial form and submit to reach waiting room
            learner_name = driver.find_element_by_name("learner_name")
            learner_name.send_keys("Learner #" + str(i))
            driver.find_element_by_xpath("//select[@id='condition_id']/option[.='Chat Sequence 1']").click()
            driver.find_element_by_xpath("//select[@id='activity_schema_id']/option[.='Quiz Review']").click()
            driver.find_element_by_xpath("//input[@type='submit']").click()
            assert len(driver.find_elements_by_class_name('timer')) > 0

        # Wait for group formation timer to expire and reach first page of task
        for handle in driver.window_handles:
            driver.switch_to_window(handle)
            WebDriverWait(driver, 60).until(lambda driver: driver.title == "Page 0")

if __name__ == '__main__':
    unittest.main()
