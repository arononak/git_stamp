// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// Base class used for polymorphism.
///
/// Only used in [Commit] and [Tag] classes.
abstract class Dateable {
  /// What is the current creation date of the object.
  String get date;
}
