class BusinessSupportPage
  DATA = {
    slug: APP_SLUG,
    content_id: "6f34c053-2f99-48a3-81e3-955fae00df69",
    title: "Finance and support for your business",
    description: "Find business finance, support, grants and loans backed by the government.",
    need_id: "100115",

    # Sending an empty array for `paths` and `prefixes` will make sure we don't
    # register routes in Panopticon.
    paths: [],
    prefixes: [],

    state: "live",
    indexable_content: "Business finance and support finder"
  }.freeze
end
