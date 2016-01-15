//
//  Distribute.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/02/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    #else
    import AppKit
#endif

typealias Accumulator = ([NSLayoutConstraint], LayoutProxy)

private func reduce(first: LayoutProxy, rest: [LayoutProxy], combine: (LayoutProxy, LayoutProxy) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
    rest.last?.view.car_translatesAutoresizingMaskIntoConstraints = false

    return rest.reduce(([], first)) { (acc, current) -> Accumulator in
        let (constraints, previous) = acc

        return (constraints + [ combine(previous, current) ], current)
    }.0
}

/// Distributes multiple views horizontally.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, horizontally first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.trailing == $1.leading - amount }
}

/// Distributes multiple views horizontally. And makes them all the same width.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distributeEvenly(by amount: CGFloat, horizontally all: [LayoutProxy]) -> [NSLayoutConstraint] {
    var rest = all
    rest.removeAtIndex(rest.startIndex)
    guard let first = all.first else { fatalError("You need at least one LayoutProxy in the array") }
    let spacing = reduce(first, rest: rest) { $0.trailing == $1.leading - amount }
    let even = reduce(first, rest: rest) { $0.width == $1.width }
    return spacing + even
}

/// Distributes multiple views horizontally from left to right.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, leftToRight first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.right == $1.left - amount  }
}

/// Distributes multiple views horizontally from left to right. And makes them all the same width.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distributeEvenly(by amount: CGFloat, leftToRight all: [LayoutProxy]) -> [NSLayoutConstraint] {
    var rest = all
    rest.removeAtIndex(rest.startIndex)
    guard let first = all.first else { fatalError("You need at least one LayoutProxy in the array") }
    let spacing = reduce(first, rest: rest) { $0.right == $1.left - amount }
    let even = reduce(first, rest: rest) { $0.width == $1.width }
    return spacing + even
}

/// Distributes multiple views vertically.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, vertically first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
    return reduce(first, rest: rest) { $0.bottom == $1.top - amount }
}

/// Distributes multiple views vertically. And makes them all the same height
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distributeEvenly(by amount: CGFloat, vertically all: [LayoutProxy]) -> [NSLayoutConstraint] {
    var rest = all
    rest.removeAtIndex(rest.startIndex)
    guard let first = all.first else { fatalError("You need at least one LayoutProxy in the array") }
    let spacing = reduce(first, rest: rest) { $0.bottom == $1.top - amount }
    let even = reduce(first, rest: rest) { $0.height == $1.height }
    return spacing + even
}
