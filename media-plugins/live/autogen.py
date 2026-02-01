#!/usr/bin/env python3

import re


async def generate(hub, **pkginfo):
	html = await hub.pkgtools.fetch.get_page("http://download.live555.com/")
	version = (re.search(f"live.([0-9.]*).tar.gz", html)).group(1)
	live_abi = 9
	url = f"https://download.live555.com/live.{version}.tar.gz"
	artifacts = [hub.pkgtools.ebuild.Artifact(url=url)]

	ebuild = hub.pkgtools.ebuild.BreezyBuild(**pkginfo, version=version, live_abi=live_abi, artifacts=artifacts)
	ebuild.push()


# vim: ts=4 sw=4 noet
