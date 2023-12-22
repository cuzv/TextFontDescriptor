#if os(macOS)
public typealias OSFont = NSFont
public typealias OSFontDescriptor = NSFontDescriptor
#else
public typealias OSFont = UIFont
public typealias OSFontDescriptor = UIFontDescriptor
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
  let style: OSFont.TextStyle
  let weight: OSFont.Weight
  let width: OSFont.Width
  let design: OSFontDescriptor.SystemDesign

  public init(family: String? = nil, size: CGFloat = 0, style: OSFont.TextStyle = .body, weight: OSFont.Weight = .regular, width: OSFont.Width = .init(rawValue: 0), design: OSFontDescriptor.SystemDesign = .default) {
    self.family = family
    self.size = size
    self.style = style
    self.weight = weight
    self.width = width
    self.design = design
  }

  public var osFont: OSFont {
    var descriptor: OSFontDescriptor

    if let family = family {
      // Custom font
      descriptor = OSFontDescriptor(fontAttributes: [
        .family: family,
        .size : size,
        .traits: [
          OSFontDescriptor.TraitKey.weight: weight,
          OSFontDescriptor.TraitKey.width: width,
        ],
      ])
    } else {
      // System font
      let styles: [OSFont.TextStyle] = [
        .largeTitle, .title1, .title2, .title3,
        .headline, .subheadline, .body,
        .callout, .footnote, .caption1, .caption2,
      ]

      if styles.contains(style) {
        descriptor = OSFont.preferredFont(forTextStyle: style)
          .fontDescriptor
          .addingAttributes([
            .traits : [
              OSFontDescriptor.TraitKey.weight: weight,
              OSFontDescriptor.TraitKey.width: width,
            ]
          ])
      } else {
        if #available(macOS 13.0, iOS 16.0, *) {
          descriptor = OSFont.systemFont(ofSize: size, weight: weight, width: width)
            .fontDescriptor
        } else {
          descriptor = OSFont.systemFont(ofSize: size, weight: weight)
            .fontDescriptor
            .addingAttributes([.traits : [OSFontDescriptor.TraitKey.width: width]])
        }
      }
    }

    descriptor = descriptor.withDesign(design) ?? descriptor
    let font = OSFont(descriptor: descriptor, size: 0)

#if os(macOS)
    return font ?? OSFont.preferredFont(forTextStyle: style)
#else
    return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
#endif
  }

  public func with(family: String?, design: OSFontDescriptor.SystemDesign, scale: CGFloat) -> Self {
    .init(
      family: family,
      size: size * scale,
      style: style,
      weight: weight,
      width: width,
      design: design
    )
  }
}

extension OSFont {
  public static func new(_ descriptor: TextFontDescriptor) -> OSFont {
    descriptor.osFont
  }
}
