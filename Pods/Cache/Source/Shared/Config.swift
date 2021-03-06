/**
 Configuration needed to create a new cache instance
 */
public struct Config {

  /// Front cache type
  public let frontKind: StorageKind
  /// Back cache type
  public let backKind: StorageKind
  /// Expiry date that will be applied by default for every added object
  /// if it's not overridden in the add(key: object: expiry: completion:) method
  public let expiry: Expiry
  // Maximum size of the cache storage
  public let maxSize: UInt

  // MARK: - Initialization

  /**
   Creates a new instance of Config.

   - Parameter frontKind: Front cache type
   - Parameter backKind: Back cache type
   - Parameter expiry: Expiry date that will be applied by default for every added object
   - Parameter maxSize: Maximum size of the cache storage
   */
  public init(frontKind: StorageKind, backKind: StorageKind, expiry: Expiry, maxSize: UInt) {
    self.frontKind = frontKind
    self.backKind = backKind
    self.expiry = expiry
    self.maxSize = maxSize
  }
}

// MARK: - Defaults

extension Config {

  /**
   Default configuration used when config is not specified
   */
  public static var defaultConfig: Config {
    return Config(
      frontKind: .Memory,
      backKind: .Disk,
      expiry: .Never,
      maxSize: 0)
  }
}
