//
//  GifView.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/18.
//

import SwiftUI

import ComposableArchitecture

struct GifView: View {
    let store: StoreOf<GifFeature>
    
    var body: some View { ZStack {
        GeometryReader { proxy in
            AsyncImage(url: URL(string: store.playerState.urls.thumbnail)) { result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .blur(radius: 20)
        }
        .ignoresSafeArea(edges: .all)
        
        PlayerView(store: store.scope(state: \.playerState, action: \.playerAction))
        
        if store.playerState.isShowingPlayPauseAnimation {
            Image(systemName: store.playerState.isPaused ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .shadow(radius: 10)
        }
        
        LinearGradient(
            gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
            startPoint: .center,
            endPoint: .bottom
        )
        .ignoresSafeArea(edges: .bottom)
        
        if store.playerState.isBuffering {
            ProgressView()
        }
        
        ProgressViewEx(
            progressColor: .darkGray,
            trackColor: .clear,
            style: .bar,
            progress: Binding(
                get: { store.playerState.bufferTime / store.gif.duration },
                set: { store.send(.playerAction(.seek($0 * store.gif.duration))) }
            )
        )
        .frame(maxHeight: .infinity, alignment: .top)
        
        SliderEx(
            thumbColor: .clear,
            maxTrackColor: .clear,
            value: Binding(
                get: { store.playerState.currentTime / store.gif.duration },
                set: { store.send(.playerAction(.seek($0 * store.gif.duration))) }
            )
        )
        .offset(y: -15)
        .padding(.horizontal, -14)
        .frame(maxHeight: .infinity, alignment: .top)
        
        HStack { VStack(alignment: .leading, spacing: 6) {
            Spacer()
                
            HStack {
                if let url = store.user.profileImageUrl {
                    AsyncImage(
                        url: URL(string: url),
                        content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        },
                        placeholder: { ProgressView() }
                    )
                    .frame(width: 60, height: 60)
                    .shadow(radius: 5)
                }
                    
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(store.gif.createDate.prettyDate())")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .shadow(radius: 5)
                        
                    HStack(spacing: 3) {
                        Text("\(store.user.name ?? store.user.username)")
                            .font(.system(size: 18, weight: .bold))
                            .shadow(radius: 5)
                            
                        if store.gif.verified {
                            Image(systemName: "checkmark.seal")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .shadow(radius: 5)
                        }
                    }
                }
            }
                
            if let desc = store.gif.description, !desc.isEmpty {
                Text(desc)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .shadow(radius: 5)
            } else if let desc = store.user.description, !desc.isEmpty {
                Text(desc)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .shadow(radius: 5)
            }
        }
        .padding()
            
        Spacer()
            
        VStack(spacing: 4) {
            Spacer()
                
            Image(systemName: "play.rectangle.on.rectangle.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .shadow(radius: 5)
                
            Text(store.gif.views.prettyFormat())
                .font(.system(size: 12))
                .padding(.bottom)
                .shadow(radius: 5)
                
            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .shadow(radius: 5)
                
            Text(store.gif.likes.prettyFormat())
                .font(.system(size: 12))
                .padding(.bottom)
                .shadow(radius: 5)
                
            if store.gif.hasAudio {
                Button(action: {
                    store.send(.playerAction(.toggleMuted))
                }) {
                    Image(systemName: FeedsFeature.isMuted ? "speaker.circle.fill" : "speaker.wave.2.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(radius: 5)
                }
                .tint(.white)
            } else {
                Image(systemName: "speaker.slash.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .shadow(radius: 5)
            }
                
            Text(store.gif.hasAudio ? FeedsFeature.isMuted ? "Unmute" : "Mute" : "No Audio")
                .font(.system(size: 12))
                .padding(.bottom)
                .shadow(radius: 5)
        }
        .padding()
        }
    }
    .onTapGesture {
        store.send(.playerAction(.togglePause))
    }
    .preferredColorScheme(.dark)
    }
}

#if DEBUG
struct GifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView(
            store: Store(
                initialState: GifFeature.State(
                    id: UUID(),
                    gif: GifList.sample.gifs[0],
                    user: GifList.sample.users[0],
                    pageIndex: 0
                ),
                reducer: { GifFeature() }
            )
        )
    }
}
#endif
