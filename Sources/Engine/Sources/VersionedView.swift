//
// Copyright (c) Nathan Tannar
//

import SwiftUI

/// A view that's `Body` is statically conditional on version availability
///
/// Because the view is statically conditional, `AnyView` is not needed
/// for type erasure. This is unlike `@ViewBuilder` which  requires an
/// `if #available(...)` conditional to be type-erased by `AnyView`.
///
/// > Important: The only `DynamicProperty` a `VersionedView`
/// can only contain is a `Binding`
///
/// By default, unsupported versions will resolve to `EmptyView`. Supported
/// versions that don't have their body implemented will resolve to the next
/// version body that is implemented.
///
/// > Tip: Use ``VersionedView`` and ``VersionedViewModifier``
/// to aide with backwards compatibility.
///
public protocol VersionedView: View where Body == Never {
    associatedtype V5Body: View = V4Body

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
    @MainActor @ViewBuilder var v5Body: V5Body { get }

    associatedtype V4Body: View = V3Body

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor @ViewBuilder var v4Body: V4Body { get }

    associatedtype V3Body: View = V2Body

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor @ViewBuilder var v3Body: V3Body { get }

    associatedtype V2Body: View = V1Body

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor @ViewBuilder var v2Body: V2Body { get }

    associatedtype V1Body: View = EmptyView

    @MainActor @ViewBuilder var v1Body: V1Body { get }
}

extension VersionedView where V5Body == V4Body {
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, xrOS 1.0, *)
    @MainActor public var v5Body: V5Body { v4Body }
}

extension VersionedView where V4Body == V3Body {
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor public var v4Body: V4Body { v3Body }
}

extension VersionedView where V3Body == V2Body {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor public var v3Body: V3Body { v2Body }
}

extension VersionedView where V2Body == V1Body {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor public var v2Body: V2Body { v1Body }
}

extension VersionedView where V1Body == EmptyView {
    @MainActor public var v1Body: V1Body { EmptyView() }
}

extension VersionedView where Body == Never{
    public var body: Never {
        bodyError()
    }

    public static func _makeView(
        view: _GraphValue<Self>,
        inputs: _ViewInputs
    ) -> _ViewOutputs {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return V5Body._makeView(view: view[\.v5Body], inputs: inputs)
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return V4Body._makeView(view: view[\.v4Body], inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            return V3Body._makeView(view: view[\.v3Body], inputs: inputs)
        } else if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            return V2Body._makeView(view: view[\.v2Body], inputs: inputs)
        } else {
            return V1Body._makeView(view: view[\.v1Body], inputs: inputs)
        }
    }

    public static func _makeViewList(
        view: _GraphValue<Self>,
        inputs: _ViewListInputs
    ) -> _ViewListOutputs {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return V4Body._makeViewList(view: view[\.v4Body], inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            return V3Body._makeViewList(view: view[\.v3Body], inputs: inputs)
        } else if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            return V2Body._makeViewList(view: view[\.v2Body], inputs: inputs)
        } else {
            return V1Body._makeViewList(view: view[\.v1Body], inputs: inputs)
        }
    }

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func _viewListCount(
        inputs: _ViewListCountInputs
    ) -> Int? {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return V4Body._viewListCount(inputs: inputs)
        } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            return V3Body._viewListCount(inputs: inputs)
        } else {
            return V2Body._viewListCount(inputs: inputs)
        }
    }
}

// MARK: - Previews

struct VersionedView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    struct Preview: VersionedView {
        var v5Body: some View { Text("V5") }
        var v4Body: some View { Text("V4") }
        var v3Body: some View { Text("V3") }
        var v2Body: some View { Text("V2") }
        var v1Body: some View { Text("V1") }
    }
}
