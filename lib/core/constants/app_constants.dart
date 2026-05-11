/// Mock data for all screens — uses Stitch placeholder images
/// Mock data for all screens — uses Stitch placeholder images
class ShowItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? badge;
  final double? rating;
  final double? progress;

  const ShowItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badge,
    this.rating,
    this.progress,
  });
}

class EpisodeItem {
  final int number;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final double? progress;
  final bool locked;

  const EpisodeItem({
    required this.number,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    this.progress,
    this.locked = false,
  });
}

class CategoryItem {
  final String title;
  final String? imageUrl;

  const CategoryItem({
    required this.title,
    this.imageUrl,
  });
}

abstract final class MockData {
  // ── Image URLs from Stitch exports ──
  static const _base = 'https://lh3.googleusercontent.com/aida-public/';

  static const heroImage =
      '${_base}AB6AXuCwp8xYrLx9DOTsNLat3uUjZ3uBvEjJTGLowkFj82D4i9oMWlo09Ltt6SCu3mix598DGcmbACAHrN-yUK6cTp71MgMyCAafFYesb1qFktRl2K-eh6TgyBAlJNw2bx_HwODoOhR-JCpE-i_GANqsEgokbD0tXdz7tS4HJaRkZPNV89dn3AqrFxATw_h_PvvfmOUUAJVHubdT4gs2xOGWqDQXV539M9wOGdDcqQhfACqKQAOZw0fySGq_W9vxPplGA_tKR8ZNC4OyK6U';

  static const imgStarryNight =
      '${_base}AB6AXuBNQkjGdszW1dHLJTcTk-mh9KUttacwgfvmnFUMB-TPzh4eJviY1PosrTRLg_hNEKjcliPKBnkgxz2Fdc4i7m0UVzcwgtdQOxh0s6hynSvJdCCyq2g7UMomrnscjGQypVXPxOUMG0Ol96FhHtblWN5PK_w4mprgNXKF38EQJe-fbcqMILoMNbCBrsqrlpejIr9kb91s7PzUYMv-1WgKvJWy7yMOJ2gPRdojjqaU0Zqsbl5e1JaaKHDKvKPmLVoocM48vjLw-jk1ZQg';

  static const imgCloudBuddies =
      '${_base}AB6AXuBOQBMebU4CGRc-M_H6hzKUEqupF5amoEfOlFC18KVDUL65yhtUY-DbS2j3w4d9tRmC3Y9ZU_IZVhnBm2j_Yr-wMWyu2_rvc-xRxaz2RwGFmdsUDaGY68OheS3r9K4BiGX5TJksnT63Gc8qu3i6fQiemPdMEp_x0H_asNtKSAcUdVL-eckprU_6Swe33jXohJ96hV4pkwsaAvdXzCj6f6_BPt3ZLmcREoFkR7-kihf51myh6fg1VeKUzr3hklXXHKNCeYaz-Bij0EE';

  static const imgSweetBakes =
      '${_base}AB6AXuDLBSd0-Bhrc5qcM8vTjzW8ym_CK_Zi37HXgF1XtsP5tvHhiu_uhkZO7dIlSR8BAEoNzPr3lz4JQVtokdPAiIXbzLJO-vR9ZUZkI7jwPLHzIYTforJIbzztjhkxmxJwkU5bjd1RjkqWgh__Fl52xhh2OV_ii87pOuNOg3k4Fd8jrhbabdcWcVX7tmHmnoy8tNFs34VpZlGmyOlAeI6JCHBB7BOMFfy7vaXODmvPZRS9zxO9z0Qg9R9PYYnKnDp9PTqi9foLDUfMzEc';

  static const imgBloom =
      '${_base}AB6AXuA5TJIJ3Gnz-SLZJD_PjjOvipXvwNYKm6vP8sG3H7Wr9-huPoLwcXM8TBPbhRWRGrg0xHrfiPzyBhrXd6b1RQDmZggX6wJBaq1v6mQE2Xfyit9-29AFG7GVdP8Nrg2mpTchLhPkfZ-sQWROOCXA4V9OG4VgBYC6UxyC2rUFSH_dSh6PxAmYotMNm67W5xBsr1qtkqsSKlLQA1RtB3WTVUoC3dlGwMQ1A5M5hpBAuIKHSi1NKA1-pMBqGXXaWJ4YtAgJjMWts9zBzAk';

  static const imgCeremony =
      '${_base}AB6AXuDzBpOJt5MnQpReHLYhnHsc5cDOh6dXA-6-oYDsYNTrwhQP3b_WT6P_h3UeFQVxQfgDIkuWdelX0ABsRKf7EgE7tfWxzGAihl3j_ZHW1Lf7K9AV_gHsocMZ5pRFNovn-IAo_t5sdwc2q_s9kiwris6Aq1qjdkLpzdE9xT6KassSUQ8lPtduorWfl9HZc1upkerttMym7CpHwRRfEvfaVAJgCpkAAAwAQeUCbRyyTnauVNXDtrrfjngrAnPRHFKciItjieXyKGBKmCo';

  static const imgMacaron =
      '${_base}AB6AXuAJrJWNCUhfAoko584WMkJNuVlCmrZ4N4iR00-MtrNLCrLGW1EpzZ3hFTPTgjyYl0lyxZ-Gg8yCuVJouxPPxGzDQAJkxxbkGX0LLdTHO6dTkv0BU-2wk1vAoyOP1q9T4qEpJi09XWgNEJuZXtHaNdovCj3UFY29UE7MOqUc1rQhlRAsECgoZDxMHVT1y8jy2ySZBOpKRh0eQUw-89qqwMip1tCUFyGsbKWrc35mLtsWEMcBrwAZo6eFgSQ6BsmK7hsMsH9uSUzdRI4';

  static const imgMeadows =
      '${_base}AB6AXuDy4VZ0IIxBr5vR-yucYwfNunIUnAeip9u96J6eCJy925_Vwj4J-Y-aJPTxEbOBge7vFT_CUDTi9mKnSlOghtLpPJL1fcf0IKmIlAV2KhuxsKz0L-WGHxnCCOIwRoney0UlAmF3cRIvICLIN6S5Nhpoy2sI6RNsikPrQATMkvIONh1L2wEoPq5GtM-6Dalj7TeovTxpcWZt1iKJN-Kzam5jPzVV8oe1rp-Esr_nk9vMTPc1vRMOpTgYUpEF5Zl4gaezyVuWjLHWF-k';

  static const imgMoonlight =
      '${_base}AB6AXuAyNi4Zvzac3VcoDActxDPjiqeFK52xYTo0O-evkYF6HIq_eYWfdYf_dOZbfZW-Gb4wIiq_BUKAsDVKB534AD6lUjTtTkPIZZJaaLYBOYUo92VnwvyoRk0cQFOHKSQCWbq8yAQ3WQbfV8n7c1H2GywmcW0pSdHFs_eQiFjSgb_q2gNIHJyJwdFeiJDPbZzEMoOyKVjJHWBY9ZIkkYgCbpKCJnH2YGvIEl4uqe8-Uk6SuK2ZyCk8_LZBYUsN_neK3klwpKmzgThPRcs';

  static const imgStarlight =
      '${_base}AB6AXuCS2PjjTT5U3R8oVWH1-6VGOAv4mRIiPqWAvNLmAt8vQitYYO0lRo_EcuQYXzvFgR_4-o0qdUX7WCgDVXgTzxWfVnm-QSnmWz9lCf2RCNpMC4djRdZd3K8J2F3Xvmpj0N1CbhX1OIkeXWB-lMWEQwkFGZ7kVygOVEvfGCID4TT58irwvA0nEyhwBFbyucHDKLVPJ0lbGXJtcONUwRmPRf0A8ly12MlCpkmoXJU4B9gwa_gLR0ky0oslxMjCLhlCdIC-M6tz0-2yJPA';

  static const imgEchoValley =
      '${_base}AB6AXuDBqymK6zBpuEqWcbpMom4CYnB5ZdUHxRfkqRgjQoDu30ZVp6-Ls049pja8bsQBf1rum94s-itWpp_KV4oRQfYT5KOwyTH24u80BNpJUDgFI2-Gcf0TXPbHQNkqb7pWKzwTLFAZhx9pC4IPByns13t_GWAH47HuQF67h8CKjqoeufHSbW4FKUZMkxzo_6OCCsaNhvWXGzUeWBdZRG5TQXydKZvCKb6X7K5YUJ7-ZkEpwiAjUAHowRCH-JH21Ls9_xBQnykqu4jPL1s';

  static const imgBloomTown =
      '${_base}AB6AXuB-5_6W1zxRv3z6myjFwbkgHAJC-JmvsVXxsJerKWXwaxc-CM0YyuUGKA_uXu88SdyQLlMlo4uQGkX8oqA6HpRsYAiMKTmCpOVUnYfiLzBa7a0L6SMxo1FYz6bV_wcKgfBoApxwFWU4MCvvPqwtu_HsJ3v6dYuXhpx2wzQ8ENDXY45PG7UJWOmfBdPlVEa0OshBIFDNNiWAhB5zIMyojjD2Cpcea7nJ5am7c-o8jCWAWekUXwXCGySJO84GCo7ZqFI78r-CZfXKyQo';

  static const imgNebulaPups =
      '${_base}AB6AXuDFuUFtuoERInaVIDYcDzNNEyNuBZSnhL4uQ0pV3a6Uo99lOaM3Ro6VSkNzqM8JQ5FGQgwx9W0INtc58HUfmax8A6n56mCDHvuSW4Gn4HtU1VVaraOMat_rL-CCA97b0VkM870WCfTvpmegp_oH00aFXSkGVbA-VTMlB5hiGoaKK69XvxPdHPLmkmAh1lHq8yGQ0OPWCqxE7pKWfeATGhvZ2oK4FLPjRbwAG6eGr0yJfG6JYmbQ-ySLkUvITGsGUOQZekknt6AWpu0';

  static const imgDreamFlow =
      '${_base}AB6AXuBVU8TfAcPQKxPR5-Ob5KlGfUUQJlBMO2v-GbFuUrct1SKfA8je8vavpInsY1iLgdmx4spl1t93zsofvS-wsELZLlOEAp0lOWAa6WXxS5TF2GmPdSZtkpkxC9KmZ95zh54tMXrAyNY5rAhTqU7SkpAeMULOmOP2i8fMfc7FAGS8vLzO_mfOOWQXL-_GAv7_NialPAXb3aan5kbJJms0v0tVQW0yNiXHPmD0WIbkUneIIHwDECuWPlhmBMfyf1DMqBWdyD4KFeB12Tw';

  static const imgOriginals =
      '${_base}AB6AXuDGhU9o15tUPYLSHt-RWFBlLRp6WOdJhFdLF33JcRy78Xa2G0iZhv_-BxlyUi4kzRlk3jGJFekQ2koOrztPi552cYr4_y308h1uPNgQ-r4k9EI0lHiBsa0wYNijx9ik6BUvc0o_7GfpRZ9IEUBCKgvTrN9q6gV5MpQde2FC1ZIPazvH262XZpXHfYsMjpr2KWdFLtPauUo0SwKvXsgT_46dMZAkyp2fJ_XAt1X3H8yU5MtFaxPLTZ8HJl_mx4dImI6DWrJ4OlFSem8';

  static const imgCinema =
      '${_base}AB6AXuDoGGKCTFREkrr9ni3jxLzLyPwP8PNkBO0Bge8C8BZBStw6ERzkL7IHWu0a5ekptx52cMx-BDXyVb-j7bUZqtI7sSk2H-bslvA1X1gbtBObJimuakOFXcstDImrTKD-nsVQKUENhR7JCsakCpNZmT80_BEJmKocCfQy0cmIrK46_1yZNDZWeB9kwShuFfx6REDL4-Sjmm4-nzd7aTSS1DtcA2dQB_2zPlcimv9pVkQ4FJmP0EsB5B7jObflA7TNNKKzcO_M6lrE034';

  static const imgPetalsHero =
      '${_base}AB6AXuBZ-pjHJporNWdZWvxam8ZosakoW7zOI0Ksf-kDBFXgjD_0B5TJMA8lkkO3qhkjznnIV-5PauRBSrG7ElULusuI0aPnOt4HPTWzFAitiJnHaoo3ia_cFckNxekoIB64u5mm3wxAnTaggXZnFa3X_hBM64R-hny8AlQ0ockjze_ha9YDESyTzPbUDYb-ukATz3b_LwoH2rDIQuD3QWg9O1_oNKCdtPyKjoBcDCFjybjw4TMFB3I4UE82nLm7kByuIokWUe9WUl7TQpM';

  static const imgEp1 =
      '${_base}AB6AXuBrsRjO5FgmVvGoYea44oHl_U0Sc7SzdV7tp2rxQ0jOd2kfSYByBaSoLiAtMbPVriBfl1zENjykvI8FUWooV10tflvYJmUk4d7-U3pRpZ8esIzld4-iYIZMZuv4Zig-M9B6ErNoAxfkQga4akEA1EPrii4KicmfpEoAZe2TpWL3BKCf2UNg9yDtC25ag8jrweFQ3_tMDojIc-cl4sLsqyqzP0OtkKDbKPxvUIOMXM_Vrry8YMzMic8Bw4P36cZVKcEUMS4SkBIx474';

  static const imgEp2 =
      '${_base}AB6AXuAubHkLsJcNPQFEiNWR-1iD49yCHlylZsboR6kiYTph4tggE0cxryOVCFCfB1TAAEMhRhYX8eD6ZoVWDJta_m0HmGgeh0IrYgaFkpVya17YAe3MmedIiQmthJCWT7dMGbuFM1kUWIC0XeaDN2ZJD8UWEJ0F1UOxaXPI3gAfYgUCmv58N4McDCPN4sBKeM0T8J75tXb1ZVwSHil1jvIGEX_s_idbu8N4wdee4Z99UQtEzEUfFz5rav0Huynn6kVIMx3h54yVuytUtig';

  static const imgEp3 =
      '${_base}AB6AXuBoHTCJVXy3uBGEoFGJE-HjkjaHy3F8NnvmTEdBxauKd0Kv96uVdRQg_IumE7kpviXgDGNw7P0gLhIos4TrUd1vU4s8_jQDe0Ag4AW2o_wdfOiigTzMa09swWpQX1UZKm3tb4wLfLOSj6UfO0A-GADaciGQAAvXADczaEY3Y39Im3O-lHn7hug9yWs-GJizcC1fE8k-0ngBZks0TRe3YBWCm_nalXgCdHoBf8lMLqFAfb5kap8eQXalcp73Z5HWFmP57G6u8wQVcGM';

  static const imgBakery =
      '${_base}AB6AXuA7KGEiEnA_FBSmEtlPzAg6ol0rWVHxcdQ2J6vVYUSjQ0PS6AmnhsALz64Nj9Ee6qXLhgd6E6mz6AWU2tebAtYfBgI9W26VI7IcMGvgSSnqjhrB6ukNDww2qE_IuBwMdfzXScJvHnt4v1A7h60nkOHKEzGa_jotCD9BMWfWTGtu4_QgJHQEJJATSomdGEPqRE7fwK3oECY5CW47_XGpZOiB1MiAIt6fr8dmL5Cpr-E7KZcYFfqnaOW36eUnt12AyFkGqpHJ6hbTCUA';

  // ── Section data ──
  static const trendingNow = [
    ShowItem(id: '1', title: 'Starry Night', subtitle: 'Drama • 2h 15m', imageUrl: imgStarryNight),
    ShowItem(id: '2', title: 'Cloud Buddies', subtitle: 'Animation • Season 1', imageUrl: imgCloudBuddies),
    ShowItem(id: '3', title: 'Sweet Bakes', subtitle: 'Reality • Episode 4', imageUrl: imgSweetBakes),
    ShowItem(id: '4', title: 'Bloom', subtitle: 'Documentary • 1h 40m', imageUrl: imgBloom),
  ];

  static const topRated = [
    ShowItem(id: '5', title: 'Ceremony', subtitle: 'Art • 9.8 Rating', imageUrl: imgCeremony, rating: 9.8),
    ShowItem(id: '6', title: 'Macaron Dreams', subtitle: 'Short • 9.5 Rating', imageUrl: imgMacaron, rating: 9.5),
    ShowItem(id: '7', title: 'Golden Meadows', subtitle: 'Nature • 9.2 Rating', imageUrl: imgMeadows, rating: 9.2),
  ];

  static const newReleases = [
    ShowItem(id: '8', title: 'Floral Path', subtitle: 'Romance • Just Added', imageUrl: imgBloom, badge: 'NEW'),
    ShowItem(id: '9', title: 'Night Walk', subtitle: 'Mystery • Just Added', imageUrl: imgStarryNight, badge: 'NEW'),
  ];

  static const continueWatching = [
    ShowItem(id: '10', title: 'Moonlight Whiskers', subtitle: 'S1 : E4 • 12m left', imageUrl: imgMoonlight, progress: 0.75),
    ShowItem(id: '11', title: 'Sweet Treats Journey', subtitle: 'S2 : E1 • 24m left', imageUrl: imgBakery, progress: 0.5),
  ];

  static const libraryItems = [
    ShowItem(id: '12', title: 'Starlight Gala', subtitle: 'Movie', imageUrl: imgStarlight, badge: '4K'),
    ShowItem(id: '13', title: 'Echo Valley', subtitle: 'TV Series', imageUrl: imgEchoValley, badge: 'NEW EPISODE'),
    ShowItem(id: '14', title: 'Bloom Town', subtitle: 'Documentary', imageUrl: imgBloomTown),
    ShowItem(id: '15', title: 'Nebula Pups', subtitle: 'Anime', imageUrl: imgNebulaPups),
    ShowItem(id: '16', title: 'Dream Flow', subtitle: 'Experimental', imageUrl: imgDreamFlow),
  ];

  static const episodes = [
    EpisodeItem(number: 1, title: 'The First Meeting', description: 'Under the old oak tree, two strangers find shelter from a sudden spring rain shower, sparking an unexpected conversation.', imageUrl: imgEp1, duration: '45:00', progress: 0.75),
    EpisodeItem(number: 2, title: 'Whispers of the Sea', description: 'A walk along the coastline reveals hidden secrets and a shared love for the horizon\'s edge.', imageUrl: imgEp2, duration: '42:15'),
    EpisodeItem(number: 3, title: 'Lost and Found', description: 'New episode arriving Friday, June 14th', imageUrl: imgEp3, duration: '44:00', locked: true),
  ];

  static const categories = [
    CategoryItem(title: 'Originals', imageUrl: imgOriginals),
    CategoryItem(title: 'Cinema', imageUrl: imgCinema),
    CategoryItem(title: 'Drama'),
    CategoryItem(title: 'Documentaries'),
  ];

  static const popularNow = [
    ShowItem(id: '17', title: 'The Art of Stillness', subtitle: 'Ikiwatch Original • Season 2', imageUrl: imgOriginals),
    ShowItem(id: '18', title: 'Botanical Wonders', subtitle: 'Nature Documentary • Film', imageUrl: imgCinema),
  ];

  static const trendingChips = ['Quietude', 'Nature Docs', 'Tea Rituals'];
}
