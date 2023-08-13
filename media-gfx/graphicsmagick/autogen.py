#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	html_data = await hub.pkgtools.fetch.get_page("https://sourceforge.net/projects/graphicsmagick/files")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None

	for link in links:
		href = link.get("href")
		if href and "latest/download" in href:
			parts = link.get('title').split("/")
			version = parts[2]

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		final_name = f"GraphicsMagick-{version}.tar.xz"
		url = f"https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/{version}/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
