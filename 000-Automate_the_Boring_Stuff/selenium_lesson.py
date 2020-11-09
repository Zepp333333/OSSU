from selenium import webdriver
browser = webdriver.Firefox()
browser.get('https://automatetheboringstuff.com')

# elem = browser.find_element_by_css_selector('.main > div:nth-child(1) > ul:nth-child(21) > li:nth-child(1) > a:nth-child(1)')
elems = browser.find_elements_by_css_selector('p')
print(len(elems))
elem = browser.find_element_by_link_text('Chapter 0 – Introduction')
elem.click()


