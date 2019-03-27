import Foundation

protocol DataService: class {
    func videoModels(completion: ([VideoModel]) -> Void)
}

class LiveVideoService: DataService {
    func videoModels(completion: ([VideoModel]) -> Void) {
        var models = [VideoModel]()
        models.append(VideoModel(id: "5b2dUgK6VV4", name: "Big Bear Bald Eagle Nest", detail: "A live feed from a bald eagle nest at Big Bear Lake, CA provided by the Friends of Big Bear Valley."))
        models.append(VideoModel(id: "Q_OrM8o2k6I", name: "Fraser Point Bald Eagle", detail: "This bald eagle nest is located near a trout hatchery in Decorah, Iowa."))
        models.append(VideoModel(id: "QtnNXb18_eU", name: "West End Bald Eagle", detail: "From the west end of Catalina Island, where the sun sets over the ocean, watch as this lifelong pair of eagle parents lay and protect eggs, feed their chicks and teach them to hunt and fly."))
        models.append(VideoModel(id: "y7e-GC6oGhg", name: "Relaxing Music and Scenery", detail: "Music, sleep music, meditation music and background music."))
        models.append(VideoModel(id: "CD3thlMScKQ", name: "Monterey Bay", detail: "From this vantage point, you can identify a number of the birds and sea mammals that find refuge in Life on the Bay."))
        models.append(VideoModel(id: "7hkF9b-OC1w", name: "Monterey Bay Sharks", detail: "Spot sharks, rays and other fishes as they cruise through our rock"))
        models.append(VideoModel(id: "oGwHtl4yQDg", name: "Al Jazeera Live", detail: "Focus on people and events that affect people's lives."))
        models.append(VideoModel(id: "fT6mzqBAqmo", name: "NASA Spacewalk", detail: "Expedition 59 Flight Engineers Nick Hague and Anne McClain of NASA are set to venture outside the International Space Station."))
        models.append(VideoModel(id: "nPyTMw--rvY", name: "Black Holes", detail: "Black holes are gigantic cosmic monsters, exotic objects whose gravity is so strong that not even light can escape their clutches."))
        models.append(VideoModel(id: "JEPRVy1jat4", name: "April the Giraffe", detail: "April the Giraffe Cam - Animal Adventure Park."))
        models.append(VideoModel(id: "z5F1a7_dsrs", name: "Tembe Elephant Park", detail: "Situated in an area that was once the ancient ‘Ivory Route' linking Mozambique and Zululand, Tembe Elephant Park is renowned for having the largest elephants in Africa – and the planet! The park is remote, lying deep in the sand forests and wetlands in northern Tongaland, right on the border between KwaZulu-Natal and Mozambique."))
        models.append(VideoModel(id: "nm_PcQeWcIY", name: "Djuma Private Game Reserve", detail: "This camera watches over Gowrie dam on Djuma Game Reserve, in the Sabi Sand Wildtuin, South Africa. In fact this is the oldest waterhole cam in Africa and the world. It’s been broadcasting LIVE from this spot since 1998. With some luck you will see big cats coming for a drink o even on a kill close by. You can also expect to see a lot of impala (light brown antelope), waterbuck (white circle on rump), nyala (males have yellow legs and females have white stripes on flanks) and many other types of mammals, birds and reptiles."))
        completion(models)
    }


}
