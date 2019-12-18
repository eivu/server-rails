module Types
  class ResourceType < Types::BaseUnion
    description 'Represents either a Folder or a CloudFile'
    possible_types CloudFileType, FolderType

    def self.resolve_type(object, _context)
      case object
      when CloudFile then CloudFileType
      when Folder then FolderType
      else
        raise ArgumentError.new('Unknown search result type')
      end
    end
  end
end
