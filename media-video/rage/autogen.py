#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	name = pkginfo.get("name")
	html_data = await hub.pkgtools.fetch.get_page(f"https://download.enlightenment.org/rel/apps/{name}")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	links.reverse()
	version = None

	for link in links:
		href = link.get("href")
		if href and href.endswith(".tar.xz"):
			version = href.rsplit("-", 1)[-1].rstrip(".tar.xz")

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		final_name = f"{name}-{version}.tar.xz"
		url = f"https://download.enlightenment.org/rel/apps/{name}/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
