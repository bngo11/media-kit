#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	base_url = "http://repository.spotify.com/pool/non-free/s/spotify-client/"
	html_data = await hub.pkgtools.fetch.get_page(f"{base_url}")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	links.reverse()
	version = None

	for link in links:
		filename = link.get("href")
		if filename and filename.endswith("_amd64.deb"):
			version = filename.split("_")[1].rsplit(".", 1)[0]
			url = f"{base_url}{filename}"

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		final_name = f"{pkginfo.get('name')}-{version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
