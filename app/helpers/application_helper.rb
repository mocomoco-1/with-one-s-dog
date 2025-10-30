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
      image: asset_url("ogp.png"),
      og: {
        type: "website",
        title: "TOMONI",
        description: "保護犬とその飼い主がともに幸せに暮らせるようにサポートするサービスです",
        url: request.original_url,
        image: asset_url("ogp.png"),
        site_name: "TOMONI"
      },
      twitter: {
        card: "summary_large_image",
        image: asset_url("ogp.png")
      }
    }
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    options = {
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      underline: true
    }
    markdown = Redcarpet::Markdown.new(renderer, options)
    markdown.render(text.to_s).html_safe
  end
end
