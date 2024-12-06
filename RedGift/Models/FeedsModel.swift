//
//  FeedsModel.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/15.
//

import Foundation

struct GifList: Codable, Equatable {
  let page: Int  // Current page number
  let pages: Int  // Total pages number
  let total: Int  // Total number of gifs in this feed
  let gifs: [Gif]
  let users: [User]
  let niches: [Niche]
  let tags: [String]
  struct Gif: Codable, Equatable {
    let id: String  // Gif ID
    let type: Int  // Gif type: 1 for video, 2 for still image
    let userName: String  // ID of the user who created this gif
    let published: Bool  // True if the gif is public, false if hidden
    let verified: Bool  // True if the gif belongs to a verified content creator
    let views: Int  // Number of views received by this gif
    let duration: Double  // Video duration in seconds (zero for still images)
    let tags: [String]  // Tags associated with this gif
    let niches: [String]  // IDs of niches this gif was added to
    let urls: URLs  // Content links for this gif
    let hls: Bool  // True if the video can be played using HLS

    // undocumented
    let likes: Int
    let hasAudio: Bool
    let createDate: Int
    let description: String?
    struct URLs: Codable, Equatable {
      let hd: String?  // Highest quality media file
      let sd: String  // Lower quality media file
      let thumbnail: String  // Static preview for this gif
    }
  }
  struct User: Codable, Equatable {
    let username: String  // User ID
    let name: String?  // Display name of the user
    let verified: Bool  // True if the user is verified
    let views: Int  // Total number of views received across all gifs
    let likes: Int  // Total number of likes received across all gifs
    let followers: Int  // Number of followers
    let profileImageUrl: String?  // URL of the user's profile image

    // undocumented
    let description: String?
  }
  struct Niche: Codable, Equatable {
    let id: String  // Niche ID
    let name: String  // Name of the niche
    let description: String  // Description of the niche
    let gifs: Int  // Number of gifs in this niche
    let subscribers: Int  // Number of subscribers to this niche
    let thumbnail: String?  // Thumbnail URL for the niche
    let cover: String?  // Cover image URL for the niche
  }
  static let sample = GifList(
    page: 0, pages: 1, total: 1,
    gifs: [
      Gif(
        id: "llss_s3_trailer", type: 1, userName: "kuku", published: true, verified: true,
        views: .random(in: 0..<Int(1e10)), duration: 30, tags: [], niches: [],
        urls: Gif.URLs(
          hd: nil,
          sd: "https://ipfs.crossbell.io/ipfs/QmeRsDdoXRQeVjyNY9pQ4J8ZgVPxeyQbS9rEmhRsU5MPYF",
          thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po"
        ), hls: true, likes: .random(in: 0..<Int(1e10)), hasAudio: true, createDate: 1_731_807_499,
        description: "lovelive superstar season 3 trailer"),
      Gif(
        id: "llss_s3_trailer", type: 1, userName: "kuku", published: true, verified: true,
        views: .random(in: 0..<Int(1e10)), duration: 30, tags: [], niches: [],
        urls: Gif.URLs(
          hd: nil,
          sd: "https://ipfs.crossbell.io/ipfs/QmeRsDdoXRQeVjyNY9pQ4J8ZgVPxeyQbS9rEmhRsU5MPYF",
          thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po"
        ), hls: true, likes: .random(in: 0..<Int(1e10)), hasAudio: true, createDate: 1_731_807_499,
        description: "lovelive superstar season 3 trailer"),
    ],
    users: [
      User(
        username: "kuku", name: "tang keke", verified: true, views: .random(in: 0..<Int(1e10)),
        likes: .random(in: 0..<Int(1e10)), followers: .random(in: 0..<Int(1e10)),
        profileImageUrl:
          "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        description: "tang keke of liella"),
      User(
        username: "kanon", name: "shibuya kanon", verified: true, views: .random(in: 0..<Int(1e10)),
        likes: .random(in: 0..<Int(1e10)), followers: .random(in: 0..<Int(1e10)),
        profileImageUrl:
          "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        description: "shibuya kanon of liella"),
    ],
    niches: [
      Niche(
        id: "anime", name: "Anime", description: "Explore a world of amazing anime gifs.",
        gifs: .random(in: 100..<1000), subscribers: .random(in: 1000..<10000),
        thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        cover: ""),
      Niche(
        id: "gaming", name: "Gaming",
        description: "The ultimate niche for gamers and game-related content.",
        gifs: .random(in: 100..<1000), subscribers: .random(in: 1000..<10000),
        thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        cover: ""),
      Niche(
        id: "memes", name: "Memes",
        description: "A niche filled with funny, quirky, and viral meme gifs.",
        gifs: .random(in: 100..<1000), subscribers: .random(in: 1000..<10000),
        thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        cover: ""),
      Niche(
        id: "sports", name: "Sports", description: "Catch all the exciting sports moments in gifs.",
        gifs: .random(in: 100..<1000), subscribers: .random(in: 1000..<10000),
        thumbnail: "https://ipfs.crossbell.io/ipfs/QmUxFy91UmZ4gDcueihRoGvTZcnnzG6UuQPXADcpLBm6Po",
        cover: ""),
    ], tags: ["tag1", "Tag Two"])
}
