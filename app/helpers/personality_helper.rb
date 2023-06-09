module PersonalityHelper
  def getUserPersonalityType
    current_user.personality_type
  end

  def getMatchingTagsForPersonalityType(personalityType)
    tags = YAML.load_file('personality_tags.yml')
    tags['personality_types'][personalityType] || []
  end
end
