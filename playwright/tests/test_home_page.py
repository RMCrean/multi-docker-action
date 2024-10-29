"""
Validate working
"""

from playwright.sync_api import Page

def test_home_page_title(page: Page, base_url: str):
    """
    Validate home page title
    """
    page.goto(base_url)
    assert page.title() == "Not Hello world"
