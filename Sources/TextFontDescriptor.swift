#if os(macOS)
public typealias NativeFont = NSFont
public typealias NativeFontDescriptor = NSFontDescriptor
#else
public typealias NativeFont = UIFont
public typealias NativeFontDescriptor = UIFontDescriptor
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

@available(iOS 13.0, *)
public struct TextFontDescriptor {
  let family: String?
  let size: CGFloat
  let style: NativeFont.TextStyle
  let weight: NativeFont.Weight
  let width: NativeFont.Width
  let design: NativeFontDescriptor.SystemDesign

  public init(family: String? = nil, size: CGFloat = 0, style: NativeFont.TextStyle = .body, weight: NativeFont.Weight = .regular, width: NativeFont.Width = .init(rawValue: 0), design: NativeFontDescriptor.SystemDesign = .default) {
    self.family = family
    self.size = size
    self.style = style
    self.weight = weight
    self.width = width
    self.design = design
  }

  public var isSystemFont: Bool {
    family == nil
  }

  public var nativeFont: NativeFont {
    var descriptor: NativeFontDescriptor

    if let family {
      // Custom font
      descriptor = NativeFontDescriptor(name: family, size: size)
        .addingAttributes([
          .traits: [
            NativeFontDescriptor.TraitKey.weight: weight,
            NativeFontDescriptor.TraitKey.width: width,
          ],
        ])
    } else {
      // System font
      let styles: [NativeFont.TextStyle] = [
        .largeTitle, .title1, .title2, .title3,
        .headline, .subheadline, .body,
        .callout, .footnote, .caption1, .caption2,
      ]

      if styles.contains(style) {
        descriptor = NativeFont.preferredFont(forTextStyle: style)
          .fontDescriptor
          .addingAttributes([
            .traits: [
              NativeFontDescriptor.TraitKey.weight: weight,
              NativeFontDescriptor.TraitKey.width: width,
            ],
          ])
      } else {
        if #available(macOS 13.0, iOS 16.0, *) {
          descriptor = NativeFont.systemFont(ofSize: size, weight: weight, width: width)
            .fontDescriptor
        } else {
          descriptor = NativeFont.systemFont(ofSize: size, weight: weight)
            .fontDescriptor
            .addingAttributes([.traits: [NativeFontDescriptor.TraitKey.width: width]])
        }
      }
    }

    descriptor = descriptor.withDesign(design) ?? descriptor
    let font = NativeFont(descriptor: descriptor, size: 0)

#if os(macOS)
    return font ?? NativeFont.preferredFont(forTextStyle: style)
#else
    return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
#endif
  }

  public func with(family fmy: String?, design: NativeFontDescriptor.SystemDesign, scale: CGFloat) -> Self {
    .init(
      family: fmy ?? family,
      size: size * scale,
      style: style,
      weight: weight,
      width: width,
      design: design
    )
  }
}

public extension NativeFont {
  static func new(_ descriptor: TextFontDescriptor) -> NativeFont {
    descriptor.nativeFont
  }
}
