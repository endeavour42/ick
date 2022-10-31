//
//  IckTests.swift
//  IckTests
//
//  Created by endeavour42 on 11/05/2022.
//

import XCTest

class TestTestTests: XCTestCase {

    private var model: IckModel!
    private let testFileUrl = Bundle.main.url(forResource: "testFile1", withExtension: nil)!
    private let badUrl = URL(string: "https://www.nonexistingsite-23t236673t2eyugw.com")!
    
    override func setUpWithError() throws {
        model = IckModel()
    }

    override func tearDownWithError() throws {
    }

    func testPerformanceExample() throws {
        measure {
        }
    }

    // MARK: common
    
    private func commonLoad(_ model: IckModel, _ job: StringJob) async throws {
        model.overrideUrl(testFileUrl)
        let result = try await job.load()
        XCTAssertEqual(result, "12345678 x90\n")
    }
    
    private func commonFail(_ model: IckModel, _ job: StringJob) {
        model.overrideUrl(badUrl)
        
        Task {
            do {
                _ = try await job.load()
                XCTAssert(false)
            } catch {
                XCTAssertNotNil(error)
            }
        }
    }
    
    // MARK: first5thCharJob
    
    func test_first5thCharJobProcess() {
        let job = model.first5thCharJob()
        XCTAssertEqual(job.process(""), "")
        XCTAssertEqual(job.process("1234567890"), "0")
        XCTAssertEqual(job.process("123456789012"), "0")
        XCTAssertEqual(job.process("123456789👨‍👩‍👧‍👦12"), "👨‍👩‍👧‍👦")
    }
    
    func test_first5thCharJobComplete() {
        let job = model.first5thCharJob()
        
        Task {
            await MainActor.run {
                model.state.items[0].value = "0"
                model.state.items[1].value = "1"
                model.state.items[2].value = "2"
                job.complete("3")
                XCTAssertEqual(model.state.items[0].value, "'3'")
                XCTAssertEqual(model.state.items[1].value, "1")
                XCTAssertEqual(model.state.items[2].value, "2")
            }
        }
    }
    
    func test_first5thCharJobFailed() {
        let job = model.first5thCharJob()
        
        Task {
            await MainActor.run {
                job.failed(NSError(domain: "", code: 0, userInfo: nil))
                XCTAssertEqual(model.state.items[0].value, "The operation couldn’t be completed. ( error 0.)")
            }
        }
    }
    
    func test_first5thCharJobLoad() async throws {
        try await commonLoad(model, model.first5thCharJob())
    }
    
    func test_first5thCharJobLoadBadUrl() async {
        commonFail(model, model.first5thCharJob())
    }
    
    private func commonPerform(_ model: IckModel, _ job: StringJob, index: Int, expected: String) async {
        model.overrideUrl(testFileUrl)
        
        await job.performAsync()
        await MainActor.run {
            let s = model.state.items[index].value
            XCTAssertEqual(s, expected)
        }
    }
    
    func test_first5thCharJobPerform() async throws {
        await commonPerform(model, model.first5thCharJob(), index: 0, expected: "'x'")
    }

    // MARK: every10thCharJob
    
    func test_every10thCharJobProcess() {
        let job = model.every10thCharJob()
        XCTAssertEqual(job.process(""), "")
        XCTAssertEqual(job.process("123"), "")
        XCTAssertEqual(job.process("123456789a"), "a")
        XCTAssertEqual(job.process("123456789b12"), "b")
        XCTAssertEqual(job.process("123456789c123456789d"), "cd")
        XCTAssertEqual(job.process("123456789e123456789f1"), "ef")
        XCTAssertEqual(job.process("123456789👨‍👩‍👧‍👦12"), "👨‍👩‍👧‍👦")
    }
    
    func test_every10thCharJobComplete() async {
        let job = model.every10thCharJob()
        
        await MainActor.run {
            model.state.items[0].value = "0"
            model.state.items[1].value = "1"
            model.state.items[2].value = "2"
            job.complete("3")
            XCTAssertEqual(model.state.items[0].value, "0")
            XCTAssertEqual(model.state.items[1].value, "3")
            XCTAssertEqual(model.state.items[2].value, "2")
        }
    }
    
    func test_every10thCharJobFailed() async {
        let job = model.every10thCharJob()
        
        await MainActor.run {
            job.failed(NSError(domain: "", code: 0, userInfo: nil))
            XCTAssertEqual(model.state.items[1].value, "The operation couldn’t be completed. ( error 0.)")
        }
    }
    
    func test_every10thCharJobLoad() async throws {
        try await commonLoad(model, model.every10thCharJob())
    }
    
    func test_every10thCharJobLoadBadUrl() {
        commonFail(model, model.every10thCharJob())
    }
    
    func test_every10thCharJobPerform() async {
        await commonPerform(model, model.every10thCharJob(), index: 1, expected: "x")
    }
    
    // MARK: wordCountJob
    
    func test_wordCountJobProcess() {
        let job = model.wordCountJob()
        XCTAssertEqual(job.process(""), "")
        XCTAssertEqual(job.process("123"), "1: 123")
        XCTAssertEqual(job.process("zoo boo"), "1: boo\n1: zoo")
        XCTAssertEqual(job.process("zoo\tboo\t\tzoo"), "2: zoo\n1: boo")
        XCTAssertEqual(job.process("b a   c"), "1: a\n1: b\n1: c")
        XCTAssertEqual(job.process("👨‍👩‍👧‍👦"), "1: 👨‍👩‍👧‍👦")
    }
    
    func test_wordCountJobComplete() async {
        let job = model.wordCountJob()
        
        await MainActor.run {
            model.state.items[0].value = "0"
            model.state.items[1].value = "1"
            model.state.items[2].value = "2"
            job.complete("3")
            XCTAssertEqual(model.state.items[0].value, "0")
            XCTAssertEqual(model.state.items[1].value, "1")
            XCTAssertEqual(model.state.items[2].value, "3")
        }
    }
    
    func test_wordCountJobFailed() async {
        let job = model.wordCountJob()
        
        await MainActor.run {
            job.failed(NSError(domain: "", code: 0, userInfo: nil))
            XCTAssertEqual(model.state.items[2].value, "The operation couldn’t be completed. ( error 0.)")
        }
    }
    
    func test_wordCountJobLoad() async throws {
        try await commonLoad(model, model.wordCountJob())
    }
    
    func test_wordCountJobLoadBadUrl() {
        commonFail(model, model.wordCountJob())
    }
    
    func test_wordCountJobPerform() async {
        await commonPerform(model, model.wordCountJob(), index: 2, expected: "1: 12345678\n1: x90\n")
    }
}
