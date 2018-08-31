package com.test;

import java.net.MalformedURLException;

import org.openqa.selenium.By;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

public class GoogleTitleTest {

	public static RemoteWebDriver driver;
	public static String appURL = "http://www.google.com";

	@BeforeClass
	@Parameters({ "browser" })
	public void setUp(String browser) throws MalformedURLException {
		System.out.println("*******************");
		driver = Browser.getDriver(browser);
		driver.manage().window().maximize();
	}

	@Test
	public void testGooglePageTitleInIE() {
		driver.navigate().to("http://www.google.com");
		String strPageTitle = driver.getTitle();
		System.out.println("Title of the Google page: "+strPageTitle);
		Assert.assertTrue(strPageTitle.equalsIgnoreCase("Google"), "Page title doesn't match");
	}

	@AfterClass
	public void tearDown() {
		if(driver!=null) {
			System.out.println("Closing the browser");
			driver.quit();
		}
	}
}