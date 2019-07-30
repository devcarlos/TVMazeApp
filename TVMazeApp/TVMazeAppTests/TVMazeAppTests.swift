//
//  TVMazeAppTests.swift
//  TVMazeAppTests
//
//  Created by Carlos Alcala on 7/29/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import XCTest
@testable import TVMazeApp

class TVMazeAppTests: XCTestCase {
    
    var show: Show?
    var person: Person?
    var episode: Episode?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Test Models
    
    func testShowModel() {
        let summary = """
            Based on the bestselling book series A Song of Ice and Fire by George R.R. Martin, this sprawling new HBO drama is set in a world where summers span decades and winters can last a lifetime. From the scheming south and the savage eastern lands, to the frozen north and ancient Wall that protects the realm from the mysterious darkness beyond, the powerful families of the Seven Kingdoms are locked in a battle for the Iron Throne. This is a story of duplicity and treachery, nobility and honor, conquest and triumph. In the Game of Thrones, you either win or you die.
            """
        show = Show(id: 1, url: "https://www.tvmaze.com/shows/82/game-of-thrones", name: "Game Of Thrones", type: nil, language: "English", genres: ["Drama", "Adventure", "Fantasy"], status: "Ended", runtime: 60, premiered: Date(), officialSite: "https://www.hbo.com/game-of-thrones", schedule: Schedule(time: "21:00", days: ["Sundays"]), rating: Rating(average: 8.1), weight: nil, network: ShowNetwork(id: 1, name: "HBO", country: MazeCountry(name: "USA", code: "US", timezone: "EST")), webChannel: nil, externals: nil, image: MazeImage(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/190/476117.jpg", original: "https://static.tvmaze.com/uploads/images/medium_portrait/190/476117.jpg"), summary: summary, updated: nil, _links: nil)
        
        // test model properties
        XCTAssertNotNil(show, "Show Object is wrong")
        XCTAssertEqual(show?.id, 1, "Show ID is wrong")
        XCTAssertEqual(show?.name, "Game Of Thrones", "Show Name is wrong")
        XCTAssertEqual(show?.language, "English", "Show Language is wrong")
        XCTAssertEqual(show?.genres, ["Drama", "Adventure", "Fantasy"], "Show Genres is wrong")
        XCTAssertEqual(show?.status, "Ended", "Show Status is wrong")
        XCTAssertEqual(show?.runtime, 60, "Show Runtime is wrong")
        XCTAssertEqual(show?.officialSite, "https://www.hbo.com/game-of-thrones", "Show Official Site is wrong")
        XCTAssertEqual(show?.schedule?.time, "21:00", "Show Time Schedule is wrong")
        XCTAssertEqual(show?.schedule?.days, ["Sundays"], "Show Days Schedule is wrong")
        XCTAssertEqual(show?.rating?.average, 8.1, "Show Average is wrong")
        XCTAssertEqual(show?.network?.name, "HBO", "Show Network is wrong")
        XCTAssertEqual(show?.network?.country.name, "USA", "Show Network Country is wrong")
        XCTAssertEqual(show?.image?.medium, "https://static.tvmaze.com/uploads/images/medium_portrait/190/476117.jpg", "Show Image is wrong")
        XCTAssertEqual(show?.summary, summary, "Show Summary is wrong")
    }
    
    func testPersonModel() {
        
        person = Person(id: 1, url: "https://www.tvmaze.com/people/14072/peter-dinklage", name: "Peter Dinklage", country: MazeCountry(name: "USA", code: "US", timezone: "EST"), birthday: Date(), deathday: nil, gender: "Male", image: MazeImage(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/74/186607.jpg", original: "https://static.tvmaze.com/uploads/images/medium_portrait/74/186607.jpg"), _links: nil)
        
        // test model properties
        XCTAssertNotNil(person, "Person Object is wrong")
        XCTAssertEqual(person?.id, 1, "Person ID is wrong")
        XCTAssertEqual(person?.name, "Peter Dinklage", "Person Name is wrong")
        XCTAssertEqual(person?.country?.name, "USA", "Person Country is wrong")
        XCTAssertEqual(person?.gender, "Male", "Person Gender is wrong")
        XCTAssertEqual(person?.image?.medium, "https://static.tvmaze.com/uploads/images/medium_portrait/74/186607.jpg", "Person Image is wrong")
    }
    
    
    func testEpisodeModel() {
        
        episode = Episode(id: 1, url: "https://www.tvmaze.com/episodes/1623968/game-of-thrones-8x06-the-iron-throne", name: "The Iron Throne", season: 8, number: 6, airdate: "05/19/2019", airtime: "21:00", airstamp: nil, runtime: 60, image: MazeImage(medium: "https://static.tvmaze.com/uploads/images/large_landscape/198/495648.jpg", original: "https://static.tvmaze.com/uploads/images/large_landscape/198/495648.jpg"), summary: "In the aftermath of the devastating attack on King's Landing, Daenerys must face the survivors.", _links: nil)
        
        // test model properties
        XCTAssertNotNil(episode, "Episode Object is wrong")
        XCTAssertEqual(episode?.id, 1, "Episode ID is wrong")
        XCTAssertEqual(episode?.name, "The Iron Throne", "Episode Name is wrong")
        XCTAssertEqual(episode?.season, 8, "Episode Season is wrong")
        XCTAssertEqual(episode?.number, 6, "Episode Number is wrong")
        XCTAssertEqual(episode?.airtime, "21:00", "Episode Airtime is wrong")
        XCTAssertEqual(episode?.runtime, 60, "Episode Runtime is wrong")
        XCTAssertEqual(episode?.image?.medium, "https://static.tvmaze.com/uploads/images/large_landscape/198/495648.jpg", "Episode Image is wrong")
        XCTAssertEqual(episode?.summary, "In the aftermath of the devastating attack on King's Landing, Daenerys must face the survivors.", "Episode Summary is wrong")
    }
    
    //MARK: - Test API Calls
    
    func testFetchShows() {
        
        let promise = expectation(description: "Fetch Show List")
        
        //callback Shows API to retrieve shows
        ShowAPI.getShows{ result in
            switch result {
            case .success(let shows):
                XCTAssertNotNil(shows, "Shows Result Must Be Valid")
                XCTAssertEqual(shows.count, 240, "Shows Result Must Be 240")
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error on Fetch Shows: \(error.localizedDescription)")
            }
        }
        
        // wait for promise
        wait(for: [promise], timeout: 10)
    }

    func testFetchShowsPagination() {
        
        let promise = expectation(description: "Fetch Show List with Pagination")
        
        //callback Shows API to retrieve shows
        ShowAPI.getShowsBy(page: 1) { result in
            switch result {
            case .success(let shows):
                XCTAssertNotNil(shows, "Shows Result Must Be Valid")
                XCTAssertEqual(shows.count, 245, "Shows Result Must Be 245")
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error on Fetch Shows: \(error.localizedDescription)")
            }
        }
        
        // wait for promise
        wait(for: [promise], timeout: 10)
    }

    func testSearchShows() {
        
        let promise = expectation(description: "Search Show List")
        
        //callback Shows API to retrieve shows
        ShowAPI.searchShowsBy(query: "Game Of Thrones") { result in
            switch result {
            case .success(let shows):
                XCTAssertNotNil(shows, "Shows Result Must Be Valid")
                XCTAssertEqual(shows.count, 3, "Shows Result Must Be 250")
                
                guard let resultShow = shows.first else {
                    XCTFail("Failed to retrieve show:")
                    return
                }
                
                let show = resultShow.show
                
                XCTAssertNotNil(show, "Show Must Be Valid")
                XCTAssertEqual(show.id, 82, "Show ID is wrong")
                XCTAssertEqual(show.name, "Game of Thrones", "Show Name is wrong")
                
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error on Search Shows: \(error.localizedDescription)")
            }
        }
        
        // wait for promise
        wait(for: [promise], timeout: 10)
    }
    
    func testFetchEpisodesByShow() {
        
        let promise = expectation(description: "Fetch Episodes List")
        
        //callback API to retrieve episodes
        ShowAPI.getEpisodes(showId: 82) { result in
            switch result {
            case .success(let result):
                
                XCTAssertNotNil(result, "Episodes result Must Be Valid")
                XCTAssertEqual(result.count, 73, "Shows Result Must Be 73")
                
                
                guard let episode = result.last else {
                    XCTFail("Failed to retrieve episode:")
                    return
                }
                
                XCTAssertNotNil(episode, "Episode Must Be Valid")
                XCTAssertEqual(episode.id, 1623968, "Episode ID is wrong")
                XCTAssertEqual(episode.name, "The Iron Throne", "Episode Name is wrong")
                
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error on Fetch Episodes: \(error.localizedDescription)")
            }
        }
        
        // wait for promise
        wait(for: [promise], timeout: 10)
    }
    
    func testSearchPeople() {
        
        let promise = expectation(description: "Fetch People List")
        
        //callback Shows API to retrieve shows
        PersonAPI.searchPersons(query: "Peter Dinklage") { result in
            switch result {
            case .success(let resultPerson):
                XCTAssertNotNil(resultPerson, "Person Result Must Be Valid")
                XCTAssertEqual(resultPerson.count, 1, "Person Result Must Be 1")
                
                guard let person = resultPerson.first?.person else {
                    XCTFail("Failed to retrieve person:")
                    return
                }
                
                XCTAssertNotNil(person, "Person Must Be Valid")
                XCTAssertEqual(person.id, 14072, "Person ID is wrong")
                XCTAssertEqual(person.name, "Peter Dinklage", "Person Name is wrong")
                
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error on Search Person: \(error.localizedDescription)")
            }
        }
        
        // wait for promise
        wait(for: [promise], timeout: 10)
    }
}
