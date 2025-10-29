module ApplicationHelper
  def page_title(title = "")
    base_title = "TOMONI"
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def default_meta_tags
    {
      site: "TOMONI",
      title: "TOMONI",
      reverse: true,
      charset: "utf-8",
      description: "保護犬とその飼い主がともに幸せに暮らせるようにサポートしていきます",
      keywords: "保護犬, 犬, しつけ, 悩み",
      canonical: request.original_url,
      separator: "|",
      image: image_url("ogp.png"),
      og: {
        type: "website",
        title: "TOMONI",
        description: "保護犬とその飼い主がともに幸せに暮らせるようにサポートするサービスです",
        url: request.original_url,
        image: image_url("ogp.png"),
        site_name: "TOMONI"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
