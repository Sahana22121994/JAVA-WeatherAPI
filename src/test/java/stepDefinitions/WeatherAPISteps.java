package stepDefinitions;

import java.io.FileInputStream;

import api.WeatherAPI;

import java.util.HashMap;
import java.util.Properties;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

public class WeatherAPISteps {
	static FileInputStream systemInput;
	static Properties prop = new Properties();
	WeatherAPI weatherAPI = new WeatherAPI();
	String url, reqBody;
	String method, id[];
	static HashMap fetchId = new HashMap();

	@Given("^a valid \"([^\"]*)\" URL with \"([^\"]*)\" method$")
	public void a_valid_something_url_with_something_method(String urlString,
			String reqMethod) throws Throwable {
		systemInput = new FileInputStream(System.getProperty("user.dir")
				+ "\\src\\test\\resources\\files\\API.properties");
		prop.load(systemInput);
		method = reqMethod;
		if (urlString.equalsIgnoreCase("register station")) {
			url = prop.getProperty("RegisterStation.URL");
		} else if (urlString
				.equalsIgnoreCase("register station without API key")) {
			url = prop.getProperty("RegisterStation.URL");
			url = url.substring(0, 47);
		}

	}

	@When("^request is sent to weather API server$")
	public void request_is_sent_to_weather_api_server() throws Throwable {
		if (method.equalsIgnoreCase("POST")) {
			weatherAPI.sendPostRequest(url, reqBody);
		} else if (method.equalsIgnoreCase("GET")) {
			weatherAPI.sendGetRequest(url);
		}
	}

	@Then("^response status code should be \"([^\"]*)\"$")
	public void response_status_code_should_be(int statuscode) throws Throwable {
		weatherAPI.responseStatusCode(statuscode);
		if (statuscode == 201) {
			String value = weatherAPI.resp();
			fetchId.put(id[3], value);
			System.out.println(fetchId);
		}
	}

	@And("^with the below (.+) for each station$")
	public void with_the_below_for_each_station(String requestbody)
			throws Throwable {
		reqBody = requestbody;
		id = requestbody.split("\"");
	}

	@And("^response should contain (.+)$")
	public void response_should_contain(String response) throws Throwable {
		weatherAPI.responseValidation(response);
	}

	@When("^request is sent to weather API server with (.+)$")
	public void request_is_sent_to_weather_api_server_with(String id)
			throws Throwable {
		System.out.println(id);
		System.out.println(fetchId);
		url = url.substring(0, 47) + "/" + fetchId.get(id)
				+ url.substring(47, url.length());
		weatherAPI.sendDeleteRequest(url);
	}
}
