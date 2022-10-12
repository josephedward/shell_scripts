from splinter import Browser
from selenium import webdriver

browser = Browser('chrome', )

browser.visit('https://learn.acloud.guru/cloud-playground/cloud-sandboxes')

username = browser.find_by_id("1-email")
username.click()
username.fill('')
password = browser.find_by_css("input[name='password']")
password.click()
password.fill('')
browser.find_by_css("button[type='submit']").click()


# browser.execute_script("document.querySelectorAll('[class^='CopyableInstanceField__Value']'))")
