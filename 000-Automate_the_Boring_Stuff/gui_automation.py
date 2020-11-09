import pyautogui

# width, height = pyautogui.size()
# pos = pyautogui.position()

# pyautogui.moveTo(10,10, duration=1.5)
# pyautogui.moveRel(200,0, duration=1.5)

# pyautogui.moveTo(x=601, y=11, duration=1.5)
# pyautogui.click()

# pyautogui.click(2500, 400); pyautogui.typewrite('Hello\n', interval=0.1)
# pyautogui.click(2500, 400); pyautogui.typewrite(['a', 'b', 'left', 'left', 'X', 'Y'], interval=0.1)
# pyautogui.hotkey('command', 'o')

pyautogui.screenshot('sshot.png')

seven = pyautogui.locateCenterOnScreen('seven.png', grayscale=False, confidence=.9)
pyautogui.moveTo(seven.x, seven.y, duration=1.5)

# r = None
# while r is None:
#     r = pyautogui.locateCenterOnScreen('seven.png', grayscale=False)
