import selenium
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
import urllib
import urllib.request
from selenium.common.exceptions import NoSuchElementException

# 첫화 URL
URL = "https://page.kakao.com/viewer?productId=54417128"

# 크롬 드라이버 셋업
driver = webdriver.Chrome(executable_path='chromedriver')
driver.implicitly_wait(time_to_wait=1)
driver.get(URL)

name = '프로야구 생존기'
# 몇화까지
ep_num = 3

# For Loop
for ep in range(0, ep_num):
    try:
        first = driver.find_element_by_xpath('/html/body/div[4]/div/div/div/img')
        first.click()
    except NoSuchElementException:
        first = driver.find_element_by_xpath('/html/body/div[3]/div/div/div/img')
        first.click()

    img_num = 1
    while True:
        try:
            img = driver.find_element_by_xpath('//*[@id="root"]/div[3]/div/div/div/div/div[1]/div[' + str(img_num) + ']/img')
            src = img.get_attribute('src')
            urllib.request.urlretrieve(src, '프로야구 생존기_%03d'%(img_num))
        except NoSuchElementException:
            break
        img_num = img_num + 1

    next_ep = driver.find_element_by_xpath('//*[@id="kpw-header"]/div[2]/span[4]')
    next_ep.click()
