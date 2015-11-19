module LinksHelper
  def read_status_url(link)
    link_to (link.read ? "Mark as Unread" : "Mark as Read"),
      link_path(id: link.id, link: { url: link.url, title: link.title, read: !link.read }),
      remote: true, method: :patch,
      class: link.read ? "btn btn-info" : "btn btn-primary"
  end
end
