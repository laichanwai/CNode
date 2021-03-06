import Foundation

/**
 Wrapper around hybrid cache to work with cached data synchronously
 */
public struct SyncHybridCache {

  /// Cache that requires sync operations
  let cache: BasicHybridCache

  // MARK: - Initialization

  /**
   Creates a wrapper around cache object.

   - Parameter cache: Cache that requires sync operations
   */
  public init(_ cache: BasicHybridCache) {
    self.cache = cache
  }

  // MARK: - Caching

  /**
   Adds passed object to the front and back cache storages.

   - Parameter key: Unique key to identify the object in the cache
   - Parameter object: Object that needs to be cached
   - Parameter expiry: Expiration date for the cached object
   */
  public func add<T: Cachable>(key: String, object: T, expiry: Expiry? = nil) {
    let semaphore = dispatch_semaphore_create(0)

    cache.add(key, object: object, expiry: expiry) {
      dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
  }

  /**
   Tries to retrieve the object from to the front and back cache storages.

   - Parameter key: Unique key to identify the object in the cache
   - Returns: Found object or nil
   */
  public func object<T: Cachable>(key: String) -> T? {
    var result: T?

    let semaphore = dispatch_semaphore_create(0)

    cache.object(key) { (object: T?) in
      result = object
      dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

    return result
  }

  /**
   Removes the object from to the front and back cache storages.

   - Parameter key: Unique key to identify the object in the cache
   */
  public func remove(key: String) {
    let semaphore = dispatch_semaphore_create(0)

    cache.remove(key) {
      dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
  }

  /**
   Clears the front and back cache storages.
   */
  public func clear() {
    let semaphore = dispatch_semaphore_create(0)

    cache.clear() {
      dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
  }
}
