/* Copyright Airship and Contributors */

import Foundation
import SwiftUI

/// Linear Layout - either a VStack or HStack depending on the direction.

struct LinearLayout: View {

    /// LinearLayout model.
    let model: LinearLayoutModel

    /// View constraints.
    let constraints: ViewConstraints

    @State
    private var numberGenerator = RepeatableNumberGenerator()

    @ViewBuilder
    @MainActor
    private func makeVStack(
        items: [LinearLayoutItem],
        parentConstraints: ViewConstraints
    ) -> some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                childItem(items[index], parentConstraints: parentConstraints)
            }
        }
        .padding(self.model.border?.strokeWidth ?? 0)
        .constraints(self.constraints, alignment: .top)
    }

    @ViewBuilder
    @MainActor
    private func makeHStack(
        items: [LinearLayoutItem],
        parentConstraints: ViewConstraints
    ) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                childItem(items[index], parentConstraints: parentConstraints)
            }
        }
        .padding(self.model.border?.strokeWidth ?? 0)
        .constraints(constraints, alignment: .leading)
    }

    @ViewBuilder
    @MainActor
    private func makeStack() -> some View {
        if self.model.direction == .vertical {
            makeVStack(
                items: orderedItems(),
                parentConstraints: parentConstraints()
            )
        } else {
            makeHStack(
                items: orderedItems(),
                parentConstraints: parentConstraints()
            )
        }
    }

    var body: some View {
        makeStack()
            .clipped()
            .background(self.model.backgroundColor)
            .border(self.model.border)
            .common(self.model)
    }

    @ViewBuilder
    @MainActor
    private func childItem(
        _ item: LinearLayoutItem,
        parentConstraints: ViewConstraints
    ) -> some View {
        let constraints = parentConstraints.childConstraints(
            item.size,
            margin: item.margin,
            padding: self.model.border?.strokeWidth ?? 0,
            safeAreaInsetsMode: .consume
        )

        ViewFactory.createView(model: item.view, constraints: constraints)
            .margin(item.margin)
    }

    private func parentConstraints() -> ViewConstraints {
        var constraints = self.constraints

        if self.model.direction == .vertical {
            constraints.isVerticalFixedSize = false
        } else {
            constraints.isHorizontalFixedSize = false
        }

        return constraints
    }

    private func orderedItems() -> [LinearLayoutItem] {
        guard self.model.randomizeChildren == true else {
            return self.model.items
        }
        var generator = self.numberGenerator
        generator.repeatNumbers()
        return model.items.shuffled(using: &generator)
    }
}

class RepeatableNumberGenerator: RandomNumberGenerator {
    private var numbers: [UInt64] = []
    private var index = 0
    private var numberGenerator = SystemRandomNumberGenerator()

    func next() -> UInt64 {
        defer {
            self.index += 1
        }

        guard index < numbers.count else {
            let next = numberGenerator.next()
            numbers.append(next)
            return next
        }
        return numbers[index]
    }

    func repeatNumbers() {
        index = 0
    }
}
