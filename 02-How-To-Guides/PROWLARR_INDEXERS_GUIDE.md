# 🔍 Prowlarr Indexers - Complete Guide

## 🎯 Best Indexers for UK (Your Setup)

### Tier 1: Essential Public Indexers (No Account Needed)

These work reliably and have good UK content:

#### 1. **1337x** ⭐⭐⭐⭐⭐
- **Why:** Best all-rounder, huge selection
- **Good for:** Movies, TV, everything
- **UK Content:** Excellent
- **Speed:** Fast
- **Add in Prowlarr:** Search "1337x"

#### 2. **TorrentGalaxy** ⭐⭐⭐⭐⭐
- **Why:** High-quality releases, well-organized
- **Good for:** Movies, TV, 4K content
- **UK Content:** Excellent
- **Speed:** Very fast
- **Add in Prowlarr:** Search "torrentgalaxy"

#### 3. **EZTV** ⭐⭐⭐⭐⭐
- **Why:** Best for TV shows, fast uploads
- **Good for:** TV shows exclusively
- **UK Content:** Excellent (includes UK TV)
- **Speed:** Very fast
- **Add in Prowlarr:** Search "eztv"

#### 4. **YTS / YIFY** ⭐⭐⭐⭐
- **Why:** Small file sizes, perfect for storage
- **Good for:** Movies (720p/1080p)
- **UK Content:** Good
- **Speed:** Fast
- **Note:** Quality is compressed but looks good
- **Add in Prowlarr:** Search "yts"

#### 5. **Nyaa** ⭐⭐⭐⭐⭐
- **Why:** Best for anime, very reliable
- **Good for:** Anime, Asian content
- **UK Content:** N/A (anime focus)
- **Speed:** Very fast
- **Bonus:** Rarely blocked, great for testing
- **Add in Prowlarr:** Search "nyaa"

---

### Tier 2: Additional Public Indexers (Add These Next)

#### 6. **Torlock** ⭐⭐⭐⭐
- **Why:** Verified torrents, no fakes
- **Good for:** Movies, TV, Music
- **Add in Prowlarr:** Search "torlock"

#### 7. **LimeTorrents** ⭐⭐⭐⭐
- **Why:** Large library, stable
- **Good for:** Everything
- **Add in Prowlarr:** Search "limetorrents"

#### 8. **The Pirate Bay** ⭐⭐⭐
- **Why:** Largest selection, but quality varies
- **Good for:** Finding rare content
- **Warning:** Use as backup, quality mixed
- **Add in Prowlarr:** Search "pirate bay"

#### 9. **Kickass Torrents** ⭐⭐⭐
- **Why:** Good mirrors available
- **Good for:** Movies, TV
- **Add in Prowlarr:** Search "kickass"

#### 10. **Zooqle** ⭐⭐⭐⭐
- **Why:** Good for TV shows
- **Good for:** TV, Movies
- **Add in Prowlarr:** Search "zooqle"

---

### Tier 3: UK-Specific Content (Recommended for UK Users)

#### 11. **TorrentLeech** (Semi-Private) ⭐⭐⭐⭐⭐
- **Why:** Excellent UK content, reliable
- **Requires:** Free registration
- **Good for:** UK TV, Movies
- **Speed:** Very fast
- **Worth it:** YES - get an account!

---

## 🇬🇧 Best for UK Content Specifically

### UK TV Shows
1. **EZTV** - Best for UK TV
2. **TorrentGalaxy** - Excellent UK releases
3. **1337x** - Good UK content
4. **TorrentLeech** - If you have account

### UK Movies
1. **1337x** - Everything
2. **TorrentGalaxy** - High quality
3. **YTS** - Smaller files

### UK Sports/Documentaries
1. **1337x** - Best selection
2. **TorrentGalaxy** - Good quality
3. **TorrentLeech** - Excellent if you have account

---

## 📋 My Recommended Setup for You

### Starter Pack (5 Indexers - Start Here!)

```
1. 1337x           - All content
2. TorrentGalaxy   - Quality releases
3. EZTV            - TV shows
4. YTS             - Space-saving movies
5. Nyaa            - Anime (bonus: good for testing DNS)
```

**Add these first - covers 90% of your needs!**

---

### Balanced Setup (10 Indexers)

Add to starter pack:

```
6. Torlock         - Verified content
7. LimeTorrents    - Large library
8. Zooqle          - More TV shows
9. Kickass         - Additional sources
10. The Pirate Bay - Backup/rare content
```

**Good balance of speed vs coverage**

---

### Power User (15+ Indexers)

Add private/semi-private if you can:

```
11. TorrentLeech   - Worth registering! 🌟
12. IPTorrents     - Semi-private
13. TorrentDay     - Private
14. AlphaRatio     - Private
15. MoreThanTV     - Private (TV focus)
```

**More sources = better results, but slower searches**

---

## 🚫 Indexers to AVOID

### Don't Waste Your Time On:

1. **ExtraTorrent** - Dead (shut down)
2. **RARBG** - Dead (shut down 2023)
3. **KickassTorrents (original)** - Dead (use mirrors)
4. **Demonoid** - Unreliable
5. **isoHunt** - Dead

**If Prowlarr shows these, skip them!**

---

## 🔧 How to Add Indexers in Prowlarr

### Step-by-Step:

1. **Open Prowlarr:** http://localhost:9696

2. **Indexers** → **Add Indexer**

3. **Search** for indexer name (e.g., "1337x")

4. **Select** the indexer from results

5. **Configure:**
   - **Enable:** ✅ Checked
   - **Priority:** 25 (default)
   - **Minimum Seeders:** 1
   - **Categories:** Select relevant (Movies, TV, etc.)

6. **Test** - Should show green checkmark ✅

7. **Save**

8. **Repeat** for each indexer

---

## 🎯 Priority Settings Explained

**Lower number = searched first**

### Recommended Priorities:

```
Priority 10-15: Private trackers (if you have them)
  - TorrentLeech: 10
  - IPTorrents: 12

Priority 20-30: Best public indexers
  - 1337x: 20
  - TorrentGalaxy: 22
  - EZTV: 25

Priority 40-50: Good backup indexers
  - Torlock: 40
  - LimeTorrents: 45
  - Zooqle: 50

Priority 75-100: Slower/less reliable
  - The Pirate Bay: 75
  - Kickass: 80
```

**Prowlarr searches all simultaneously, but reports fastest results first**

---

## 🌍 Regional Considerations (UK)

### Best for UK Users:

**These have good UK content and aren't geo-blocked:**

✅ **1337x** - Not blocked in UK
✅ **TorrentGalaxy** - Not blocked
✅ **EZTV** - Not blocked
✅ **YTS** - Not blocked
✅ **Torlock** - Not blocked

**May need VPN (sometimes blocked by ISPs):**

⚠️ **The Pirate Bay** - Some UK ISPs block
⚠️ **Kickass Torrents** - Some mirrors blocked

**With your ExpressVPN:**
- You can access any indexer
- But probably don't need VPN for the top 5 indexers

---

## 🔐 Private Trackers Worth Joining

If you want to level up your setup:

### Worth the Effort (Free Registration):

**1. TorrentLeech**
- Website: https://www.torrentleech.org
- Cost: Free (need invite or wait for open registration)
- Worth it: ⭐⭐⭐⭐⭐
- Why: Excellent UK content, fast, reliable

**2. IPTorrents**
- Cost: Free (need invite)
- Worth it: ⭐⭐⭐⭐
- Why: Good general content

### Premium (Paid - Not Required):

**3. TorrentDay**
- Cost: Donation for invite
- Worth it: ⭐⭐⭐
- Why: Only if you want absolute best quality

**You don't need private trackers!** Public indexers are fine for most users.

---

## 💡 Pro Tips

### For Best Results:

**1. Add at least 5 indexers**
- More sources = better chance of finding content
- But diminishing returns after 10

**2. Focus on quality over quantity**
- 5 good indexers > 20 broken ones

**3. Test each indexer**
- Use Prowlarr's search to verify they work
- Remove any that consistently fail

**4. Use categories**
- Enable only relevant categories (Movies, TV)
- Disable Music, Books, etc. unless you need them

**5. Set minimum seeders**
- Minimum seeders: 1-2
- Ensures you get working torrents

**6. Regional focus**
- Prioritize indexers with good UK content
- EZTV is essential for UK TV shows

---

## 🧪 Testing Your Indexers

### Quick Test:

**In Prowlarr:**

1. Click **Search** (magnifying glass icon)

2. Search for: **"Breaking Bad"**

3. You should see results from ALL your indexers

4. Each result shows which indexer it came from

**Good signs:**
- ✅ Results from multiple indexers
- ✅ Multiple seeders on results
- ✅ Recent uploads (not years old)

**Bad signs:**
- ❌ No results from an indexer
- ❌ "Query successful" but 0 results
- ❌ Timeout errors

Remove indexers that consistently fail!

---

## 📊 My Personal Recommendation for You

Based on your setup (UK, 4TB storage, family use):

### Perfect Setup:

```yaml
Priority | Indexer        | Why
---------|----------------|------------------------
20       | 1337x          | Best all-rounder
22       | TorrentGalaxy  | Quality releases
25       | EZTV           | UK TV shows
30       | YTS            | Space-saving movies
35       | Nyaa           | Anime (if needed)
40       | Torlock        | Verified content
45       | LimeTorrents   | Backup
```

**This gives you:**
- ✅ Excellent coverage
- ✅ Good UK content
- ✅ Fast searches
- ✅ Reliable results
- ✅ Not overwhelming

**Start with the top 5, add more later if needed!**

---

## 🔄 Maintenance

### Monthly:

1. **Check indexer stats:**
   - Settings → Indexers
   - Look at query counts and success rates
   - Remove consistently failing ones

2. **Test searches:**
   - Search for recent popular content
   - Verify results are current

3. **Update Prowlarr:**
   - Settings → System → Updates
   - Keep up to date for best indexer support

---

## 🆘 If Indexers Fail

### Troubleshooting:

**1. DNS/SSL errors:**
- Already fixed with DNS settings!
- If still issues, use FlareSolverr

**2. Cloudflare challenges:**
- Add FlareSolverr proxy
- Apply to affected indexers

**3. AdGuard blocking:**
- Add indexer domains to allowlist
- Or let Prowlarr use fallback DNS (already configured)

**4. Site down:**
- Check if site is actually up
- Visit in browser
- Remove if permanently dead

**5. No results:**
- Check categories are enabled
- Verify minimum seeders isn't too high
- Test with popular content

---

## ✅ Setup Checklist

### For Your 5 Essential Indexers:

- [ ] 1337x added and tested
- [ ] TorrentGalaxy added and tested
- [ ] EZTV added and tested
- [ ] YTS added and tested
- [ ] Nyaa added and tested
- [ ] All show in Radarr (Settings → Indexers)
- [ ] All show in Sonarr (Settings → Indexers)
- [ ] Test search returns results
- [ ] Request a movie in Overseerr
- [ ] Movie found and downloaded
- [ ] Movie appears in Plex

---

## 📝 Quick Add Script

Want to add all 5 essential indexers quickly?

**Manual is better** (can test each), but here's the list for copy/paste:

```
1. Indexers → Add Indexer → Search: "1337x" → Add → Test → Save
2. Indexers → Add Indexer → Search: "torrentgalaxy" → Add → Test → Save
3. Indexers → Add Indexer → Search: "eztv" → Add → Test → Save
4. Indexers → Add Indexer → Search: "yts" → Add → Test → Save
5. Indexers → Add Indexer → Search: "nyaa" → Add → Test → Save
```

**Each takes 30 seconds = 2.5 minutes total!**

---

## 🎉 Summary

**For your UK homelab, start with these 5:**

1. **1337x** - Everything
2. **TorrentGalaxy** - Quality
3. **EZTV** - TV shows (especially UK)
4. **YTS** - Space-efficient movies
5. **Nyaa** - Anime (bonus: tests DNS well)

**Add these 5, test them, and you're golden! They'll handle 90% of requests.**

**Want more?** Add Torlock and LimeTorrents next.

**Your family will be requesting content in no time! 🍿**

