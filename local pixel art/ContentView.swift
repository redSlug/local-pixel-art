//
//  ContentView.swift
//  local pixel art
//
//  Created by Brad Dettmer on 4/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var multipeerManager = MultipeerManager()
    @State private var pixelArt = PixelArt()
    @State private var showingPeerList = false
    
    var body: some View {
        NavigationView {
            VStack {
                PixelArtView(pixelArt: $pixelArt)
                    .padding()
                
                Button(action: {
                    showingPeerList = true
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.headline)
                }
                .padding()
            }
            .navigationTitle("Pixel Art")
            .sheet(isPresented: $showingPeerList) {
                PeerListView(multipeerManager: multipeerManager, pixelArt: pixelArt)
            }
            .onChange(of: multipeerManager.receivedPixelArt) { oldValue, newValue in
                if let newPixelArt = newValue {
                    pixelArt = newPixelArt
                }
            }
        }
    }
}

struct PeerListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var multipeerManager: MultipeerManager
    let pixelArt: PixelArt
    
    var body: some View {
        NavigationView {
            List(multipeerManager.connectedPeers, id: \.displayName) { peer in
                Button(action: {
                    multipeerManager.send(pixelArt: pixelArt, to: peer)
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text(peer.displayName)
                    }
                }
            }
            .navigationTitle("Share with")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

#Preview {
    ContentView()
}
