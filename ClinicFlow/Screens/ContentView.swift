//
//  ContentView.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-25.
//

import SwiftUI

struct ContentView: View {
    @Environment(LanguageManager.self) var languageManager

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(languageManager.localized("hello_world"))
                .font(.poppins(.regular, size: 17))
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(LanguageManager.shared)
}
