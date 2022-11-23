// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public enum Primary {
      public static let appleRed1 = ColorAsset(name: "AppleRed1")
      public static let nightSky1 = ColorAsset(name: "NightSky1")
      public static let oasis1 = ColorAsset(name: "Oasis1")
      public static let sheep1 = ColorAsset(name: "Sheep1")
      public static let wilderness1 = ColorAsset(name: "Wilderness1")
    }
    public enum Secondary {
      public static let appleRed2 = ColorAsset(name: "AppleRed2")
      public static let appleRed3 = ColorAsset(name: "AppleRed3")
      public static let nightSky2 = ColorAsset(name: "NightSky2")
      public static let nightSky3 = ColorAsset(name: "NightSky3")
      public static let nightSky4 = ColorAsset(name: "NightSky4")
      public static let nightSky5 = ColorAsset(name: "NightSky5")
      public static let sheep2 = ColorAsset(name: "Sheep2")
      public static let sheep3 = ColorAsset(name: "Sheep3")
      public static let sheep4 = ColorAsset(name: "Sheep4")
      public static let wilderness2 = ColorAsset(name: "Wilderness2")
    }
  }
  public enum Images {
    public static let accentColor = ColorAsset(name: "AccentColor")
    public enum Common {
      public static let checkEmpty = ImageAsset(name: "checkEmpty")
      public static let checkFill = ImageAsset(name: "checkFill")
      public static let isLeader = ImageAsset(name: "isLeader")
    }
    public enum Pray {
      public static let bubbleL = ImageAsset(name: "bubbleL")
      public static let bubbleLOther = ImageAsset(name: "bubbleLOther")
      public static let bubbleR = ImageAsset(name: "bubbleR")
      public static let comment = ImageAsset(name: "comment")
    }
    public enum Profile {
      public static let logout = ImageAsset(name: "logout")
    }
    public enum Signup {
      public static let apple = ImageAsset(name: "apple")
      public static let google = ImageAsset(name: "google")
    }
    public enum Tabbar {
      public static let cross = ImageAsset(name: "cross")
      public static let today = ImageAsset(name: "today")
    }
    public enum Today {
      public static let myHistory = ImageAsset(name: "myHistory")
      public static let taskSelect = ImageAsset(name: "taskSelect")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
