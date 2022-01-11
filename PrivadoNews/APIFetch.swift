import Foundation

class APIFetch {
    static let shared = APIFetch()

    struct Constants {
        static let toHeadlinesURL = URL(string: "https://api.spaceflightnewsapi.net/v3/articles")
        
        static let searchUrlString = "https://api.spaceflightnewsapi.net/v3/articles?title_contains="
    }
    
    private init() {}
    
    public func getTopNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let url = Constants.toHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
//                    let filteredResult = result.map({ (t) -> Article in
//                        return Article(title: t.title, url: t.url, imageUrl: t.imageUrl, newsSite: t.newsSite, summary: t.summary, publishedAt: t.publishedAt)
//                    })
                    
                    DispatchQueue.main
                        .async {
                            completion(.success(result))
                        }
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// Modules
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let url: String?
    let imageUrl: String?
    let newsSite: String?
    let summary: String?
    let publishedAt: String?
}

extension APIFetch {
    static var testData = [
        PrivadoNews.Article(title: "Submit reimbursement report", url: "github.com/diogom14.png", imageUrl: "https://swiftdeveloperblog.com/wp-content/uploads/2015/07/1.jpeg", newsSite: "Pelouro", summary: "Don't forget about taxi receipts", publishedAt: "10-01-2021"),
        PrivadoNews.Article(title: "From contractor to satellite operator: Q&A with Sidus Space CEO Carol Craig", url: Optional("https://spacenews.com/from-contractor-to-satellite-operator-qa-with-sidus-space-ceo-carol-craig/"), imageUrl: Optional("https://spacenews.com/wp-content/uploads/2022/01/Lizzie-Sat.jpg"), newsSite: Optional("SpaceNews"), summary: Optional("Sidus Space became a public company in December to help transform the Space Coast government contractor into a commercial satellite constellation operator. SpaceNews interviewed Sidus Space CEO Carol Craig, who became the first woman owner-founder of a space company to go public, to learn more about the plans as its first satellite aims to launch late this year."), publishedAt: Optional("2022-01-07T22:02:45.000Z")),
        PrivadoNews.Article(title: "Expedition 66 concludes 2021 with busy December aboard ISS", url: Optional("https://www.nasaspaceflight.com/2022/01/expedition-66-december/"), imageUrl: Optional("https://www.nasaspaceflight.com/wp-content/uploads/2022/01/51732391125_a6a60014c4_k.jpg"), newsSite: Optional("NASA Spaceflight"), summary: Optional("While many cultures celebrated their respective holiday traditions on Earth, the crew of the International Space Station (ISS) carried on with their busy schedules high above. December 2021 saw three major visiting vehicle movements, one spacewalk, and many of the research and maintenance tasks that allow the ISS to function as one of the world’s most important scientific laboratories."), publishedAt: Optional("2022-01-07T19:18:34.000Z")),
        PrivadoNews.Article(title: "Arianespace looks to transitions of vehicles and business in 2022", url: Optional("https://spacenews.com/arianespace-looks-to-transitions-of-vehicles-and-business-in-2022/"), imageUrl: Optional("https://spacenews.com/wp-content/uploads/2022/01/a5-jwst-2.jpg"), newsSite: Optional("SpaceNews"), summary: Optional("After its most active year in two decades capped by the launch of the James Webb Space Telescope for NASA, Arianespace is heading into a period of transition in 2022 marked by the introduction of new vehicles and a changing mix of customers."), publishedAt: Optional("2022-01-07T13:12:45.000Z")),
        PrivadoNews.Article(title: "Rocket Report: SpaceX raises more cash, buy your own New Glenn", url: Optional("https://arstechnica.com/science/2022/01/rocket-report-faa-delays-texas-spaceport-review-sls-slips-to-late-spring/"), imageUrl: Optional("https://cdn.arstechnica.net/wp-content/uploads/2022/01/53101_A4.jpg"), newsSite: Optional("Arstechnica"), summary: Optional("\"SpaceX ... is currently drafting responses for the over 18,000 public comments.\""), publishedAt: Optional("2022-01-07T12:00:20.000Z")),
        PrivadoNews.Article(title: "First wing of Webb telescope’s primary mirror folds into place", url: Optional("https://spaceflightnow.com/2022/01/07/first-wing-of-webb-telescopes-primary-mirror-folds-into-place/"), imageUrl: Optional("https://spaceflightnow.com/wp-content/uploads/2022/01/webb-mirror-1.jpg"), newsSite: Optional("Spaceflight Now"), summary: Optional("One of the two wings holding three of the James Webb Space Telescope’s gold-coated mirror segments folded into place Friday, setting the stage for positioning of the other wing Saturday to complete the nearly $10 billion observatory’s major deployments."), publishedAt: Optional("2022-01-07T03:42:49.000Z")),
        PrivadoNews.Article(title: "SpaceX kicks off jam-packed new year with Starlink launch and Falcon landing", url: Optional("https://www.teslarati.com/spacex-aces-first-starlink-launch-2022/"), imageUrl: Optional("https://www.teslarati.com/wp-content/uploads/2022/01/Starlink-4-5-F9-B1062-39A-010622-webcast-SpaceX-launch-landing-1.jpg"), newsSite: Optional("Teslarati"), summary: Optional("SpaceX has successfully completed its first launch – a Starlink mission – of 2022, kicking off the most ambitious annual launch manifest..."), publishedAt: Optional("2022-01-06T22:37:03.000Z")),
        PrivadoNews.Article(title: "Space Force to use navigation data from LEO constellations to detect electronic interference", url: Optional("https://spacenews.com/space-force-to-use-navigation-data-from-leo-constellations-to-detect-electronic-interference/"), imageUrl: Optional("https://spacenews.com/wp-content/uploads/2022/01/OneWeb-constellation-screenshot.jpg"), newsSite: Optional("SpaceNews"), summary: Optional("Under a $2 million contract from the U.S. Space Force, Slingshot Aerospace will develop an analytics tool that uses location data from commercial satellites in low Earth orbit to identify potential sources of electronic interference on the ground."), publishedAt: Optional("2022-01-06T22:16:45.000Z")),
        PrivadoNews.Article(title: "NASA to Host Coverage, Briefing for Webb Telescope’s Final Unfolding", url: Optional("http://www.nasa.gov/press-release/nasa-to-host-coverage-briefing-for-webb-telescope-s-final-unfolding"), imageUrl: Optional("https://www.nasa.gov/sites/default/files/thumbnails/image/james_webb_space_telescope.jpg?itok=ZdlLrwkD"), newsSite: Optional("NASA"), summary: Optional("NASA will provide live coverage and host a media briefing Saturday, Jan. 8, for the conclusion of the James Webb Space Telescope’s major spacecraft deployments."), publishedAt: Optional("2022-01-06T22:06:00.000Z")),
        PrivadoNews.Article(title: "SpaceX conducts first orbital launch of 2022 with Starlink Group 4-5", url: Optional("https://www.nasaspaceflight.com/2022/01/starlink-4-5/"), imageUrl: Optional("https://www.nasaspaceflight.com/wp-content/uploads/2022/01/NSF-2022-01-06-23-15-15-220.jpg"), newsSite: Optional("NASA Spaceflight"), summary: Optional("SpaceX launched another batch of Starlink satellites to the fourth shell of the constellation for the first global orbital launch attempt of the year."), publishedAt: Optional("2022-01-06T19:04:31.000Z")),
        PrivadoNews.Article(title: "SpaceX Falcon 9 rocket ready for first of dozens of launches in 2022", url: Optional("https://www.teslarati.com/spacex-falcon-9-ready-first-launch-2022/"), imageUrl: Optional("https://www.teslarati.com/wp-content/uploads/2022/01/GPS-III-SV05-Falcon-9-B1062-JRTI-recovery-062121-Richard-Angle-1-edit-c.jpg"), newsSite: Optional("Teslarati"), summary: Optional("Teams have rolled a Falcon 9 out of its integration hangar and raised the rocket vertical at Kennedy Space Center (KSC) Pad..."), publishedAt: Optional("2022-01-06T18:57:06.000Z"))
    ]
}
