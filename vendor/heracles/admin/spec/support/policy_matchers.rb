RSpec::Matchers.define :permit_action do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end

RSpec::Matchers.define :permit_attributes do |*attrs|
  match do |policy|
    attrs = Array(attrs)
    hash_attrs = attrs.extract_options!

    permitted_attrs       = policy.public_send(:permitted_attributes)
    permitted_hash_attrs  = permitted_attrs.extract_options!

    attrs_match       = (permitted_attrs & attrs).length == attrs.length
    hash_attrs_match  = (permitted_hash_attrs.keys & hash_attrs.keys).length == hash_attrs.keys.length

    if attrs.empty?
      # If there are no attrs, then we're expecting the policy to permit nothing.
      !permitted_attrs.empty?
    else
      attrs_match && hash_attrs_match
    end
  end

  failure_message do |policy|
    "#{policy.class} does not permit attributes #{attrs.join(', ')} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid attributes #{attrs.join(', ')} on #{policy.record} for #{policy.user.inspect}."
  end
end

RSpec::Matchers.define :be_an_authorized_action do
  supports_block_expectations

  match_unless_raises Heracles::Admin::Policy::NotAuthorizedError do |action_request_block|
    action_request_block.call
  end
end
