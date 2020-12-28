SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: zhparser; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS zhparser WITH SCHEMA public;


--
-- Name: EXTENSION zhparser; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION zhparser IS 'a parser for full-text search of Chinese';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: rum; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS rum WITH SCHEMA public;


--
-- Name: EXTENSION rum; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION rum IS 'RUM index access method';


--
-- Name: ratio(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ratio(l text, r text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      DECLARE
        diff      int;  -- levenshtein编辑距离
        l_len     int := length(l);
        r_len     int := length(r);
        short_len int;
        long_len  int;
        match_len int;
        result    int;
      BEGIN
        IF (l IS NULL) OR (r IS NULL) OR (l = '') OR (r = '') THEN
          result := 0;
        ELSE
          SELECT levenshtein(l, r)      INTO diff;
          SELECT GREATEST(l_len, r_len) INTO long_len;
          SELECT LEAST(l_len, r_len)    INTO short_len;
          -- match长度为：最长字符串减去编辑距离
          match_len := long_len - diff;
          -- 基于fuzzywuzzy公式
          -- Return a measure of the sequences’ similarity as a float in the range [0, 100].
          -- Where T is the total number of elements in both sequences, and M is the number of matches, this is 2.0*M / T. 
          -- Note that this is 100 if the sequences are identical, and 0 if they have nothing in common.
          -- https://docs.python.org/3/library/difflib.html#difflib.SequenceMatcher.ratio
          -- https://github.com/seatgeek/fuzzywuzzy
          result := ((2.0 * match_len * 100) / (long_len + short_len));
        END IF;
        RETURN(result);
      END;
    $$;


--
-- Name: zh; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION public.zh (
    PARSER = public.zhparser );

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR a WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR b WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR c WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR d WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR e WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR f WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR g WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR h WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR i WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR j WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR k WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR l WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR m WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR n WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR o WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR p WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR q WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR r WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR s WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR t WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR u WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR v WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR w WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR x WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR y WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.zh
    ADD MAPPING FOR z WITH simple;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;


--
-- Name: ahoy_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_visits (
    id bigint NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    user_id bigint,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    country character varying,
    region character varying,
    city character varying,
    latitude double precision,
    longitude double precision,
    utm_source character varying,
    utm_medium character varying,
    utm_term character varying,
    utm_content character varying,
    utm_campaign character varying,
    app_version character varying,
    os_version character varying,
    platform character varying,
    started_at timestamp without time zone
);


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_providers (
    id bigint NOT NULL,
    user_id bigint,
    data jsonb,
    provider character varying,
    uid character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auth_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_providers_id_seq OWNED BY public.auth_providers.id;


--
-- Name: bookmark_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookmark_stats (
    id bigint NOT NULL,
    bookmark_id bigint,
    date_id date,
    date_type character varying DEFAULT 'daily'::character varying,
    likes_count integer DEFAULT 0,
    dups_count integer DEFAULT 0,
    clicks_count integer DEFAULT 0,
    score integer GENERATED ALWAYS AS ((((dups_count * 3) + (likes_count * 2)) + clicks_count)) STORED
);


--
-- Name: bookmark_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookmark_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookmark_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookmark_stats_id_seq OWNED BY public.bookmark_stats.id;


--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookmarks (
    id bigint NOT NULL,
    user_id bigint,
    url character varying,
    title character varying,
    ref_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    favicon character varying,
    description text,
    dups_count integer DEFAULT 0,
    likes_count integer DEFAULT 0,
    cached_like_user_ids integer[] DEFAULT '{}'::integer[],
    comments_count integer DEFAULT 0,
    tags_count integer DEFAULT 0,
    content text,
    cached_tag_names character varying,
    cached_tag_ids bigint[] DEFAULT '{}'::bigint[],
    lang integer DEFAULT 0 NOT NULL,
    clicks_count integer DEFAULT 0,
    score integer GENERATED ALWAYS AS ((((dups_count * 3) + (likes_count * 2)) + clicks_count)) STORED,
    smart_score double precision GENERATED ALWAYS AS (((log((((((likes_count * 2) + (dups_count * 3)) + clicks_count))::numeric + 1.1)))::double precision + (date_part('epoch'::text, (created_at - '2020-08-10 00:00:00'::timestamp without time zone)) / (4500)::double precision))) STORED,
    is_rss boolean DEFAULT false NOT NULL,
    cached_tag_with_aliases_names character varying,
    cached_tag_with_aliases_ids bigint[] DEFAULT '{}'::bigint[],
    is_display boolean DEFAULT true NOT NULL,
    tsv tsvector GENERATED ALWAYS AS (((((setweight(to_tsvector('public.zh'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('public.zh'::regconfig, (COALESCE(url, ''::character varying))::text), 'A'::"char")) || setweight(to_tsvector('public.zh'::regconfig, (COALESCE(cached_tag_with_aliases_names, ''::character varying))::text), 'A'::"char")) || setweight(to_tsvector('public.zh'::regconfig, COALESCE(description, ''::text)), 'B'::"char")) || setweight(to_tsvector('public.zh'::regconfig, COALESCE(content, ''::text)), 'D'::"char"))) STORED,
    shared_at timestamp without time zone,
    pinned_comment_id bigint,
    images character varying[] DEFAULT '{}'::character varying[],
    weekly_selection_id bigint,
    excellented_at timestamp without time zone,
    is_excellent boolean DEFAULT false NOT NULL
);


--
-- Name: bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookmarks_id_seq OWNED BY public.bookmarks.id;


--
-- Name: clicks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clicks (
    id bigint NOT NULL,
    bookmark_id bigint,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clicks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clicks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clicks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clicks_id_seq OWNED BY public.clicks.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    comment text,
    user_id bigint,
    bookmark_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    id bigint NOT NULL,
    user_id bigint,
    following_user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    id bigint NOT NULL,
    user_id bigint,
    bookmark_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    type character varying NOT NULL,
    params jsonb,
    read_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: rss_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rss_sources (
    id bigint NOT NULL,
    tag_name character varying NOT NULL,
    url character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tag_id bigint,
    processed_at timestamp without time zone,
    is_display boolean DEFAULT true NOT NULL,
    creator_id bigint DEFAULT 100 NOT NULL
);


--
-- Name: rss_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rss_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rss_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rss_sources_id_seq OWNED BY public.rss_sources.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tag_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_subscriptions (
    id bigint NOT NULL,
    user_id bigint,
    tag_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tag_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_subscriptions_id_seq OWNED BY public.tag_subscriptions.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id bigint NOT NULL,
    tag_id bigint,
    bookmark_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    bookmarks_count integer DEFAULT 0,
    subscriptions_count integer DEFAULT 0,
    is_rss boolean DEFAULT false,
    preferred_id bigint,
    auto_extract boolean DEFAULT true,
    description text,
    remote_img_url character varying
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying,
    password_digest character varying,
    remember_token character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    extension_token character varying,
    username character varying,
    about text,
    homepage character varying,
    followers_count integer DEFAULT 0,
    followings_count integer DEFAULT 0,
    bookmarks_count integer DEFAULT 0,
    score integer GENERATED ALWAYS AS ((bookmarks_count + (followers_count * 5))) STORED,
    comments_count integer DEFAULT 0,
    tags_count integer DEFAULT 0,
    taggings_count integer DEFAULT 0,
    admin boolean DEFAULT false,
    follow_tags_count integer DEFAULT 0,
    default_bookmark_lang integer DEFAULT 0 NOT NULL,
    enable_email_notification boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: weekly_selections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weekly_selections (
    id bigint NOT NULL,
    bookmarks_count integer DEFAULT 0 NOT NULL,
    description text,
    description_en text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title character varying NOT NULL,
    is_published boolean DEFAULT false NOT NULL
);


--
-- Name: weekly_selections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.weekly_selections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weekly_selections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.weekly_selections_id_seq OWNED BY public.weekly_selections.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: ahoy_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);


--
-- Name: ahoy_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);


--
-- Name: auth_providers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_providers ALTER COLUMN id SET DEFAULT nextval('public.auth_providers_id_seq'::regclass);


--
-- Name: bookmark_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmark_stats ALTER COLUMN id SET DEFAULT nextval('public.bookmark_stats_id_seq'::regclass);


--
-- Name: bookmarks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks ALTER COLUMN id SET DEFAULT nextval('public.bookmarks_id_seq'::regclass);


--
-- Name: clicks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clicks ALTER COLUMN id SET DEFAULT nextval('public.clicks_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: rss_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rss_sources ALTER COLUMN id SET DEFAULT nextval('public.rss_sources_id_seq'::regclass);


--
-- Name: tag_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.tag_subscriptions_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: weekly_selections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_selections ALTER COLUMN id SET DEFAULT nextval('public.weekly_selections_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ahoy_events ahoy_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events
    ADD CONSTRAINT ahoy_events_pkey PRIMARY KEY (id);


--
-- Name: ahoy_visits ahoy_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits
    ADD CONSTRAINT ahoy_visits_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auth_providers auth_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_providers
    ADD CONSTRAINT auth_providers_pkey PRIMARY KEY (id);


--
-- Name: bookmark_stats bookmark_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmark_stats
    ADD CONSTRAINT bookmark_stats_pkey PRIMARY KEY (id);


--
-- Name: bookmarks bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (id);


--
-- Name: clicks clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clicks
    ADD CONSTRAINT clicks_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: rss_sources rss_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rss_sources
    ADD CONSTRAINT rss_sources_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tag_subscriptions tag_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_subscriptions
    ADD CONSTRAINT tag_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: weekly_selections weekly_selections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_selections
    ADD CONSTRAINT weekly_selections_pkey PRIMARY KEY (id);


--
-- Name: boomkark_rum_tsv_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boomkark_rum_tsv_idx ON public.bookmarks USING rum (tsv);


--
-- Name: idx_similar_by_tag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_similar_by_tag ON public.bookmarks USING rum (cached_tag_with_aliases_ids);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_ahoy_events_on_name_and_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");


--
-- Name: index_ahoy_events_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);


--
-- Name: index_ahoy_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_user_id ON public.ahoy_events USING btree (user_id);


--
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);


--
-- Name: index_ahoy_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_visits_on_user_id ON public.ahoy_visits USING btree (user_id);


--
-- Name: index_ahoy_visits_on_visit_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);


--
-- Name: index_auth_providers_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auth_providers_on_provider_and_uid ON public.auth_providers USING btree (provider, uid);


--
-- Name: index_auth_providers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auth_providers_on_user_id ON public.auth_providers USING btree (user_id);


--
-- Name: index_bookmark_stats_on_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmark_stats_on_bookmark_id ON public.bookmark_stats USING btree (bookmark_id);


--
-- Name: index_bookmark_stats_on_date_id_and_date_type_and_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bookmark_stats_on_date_id_and_date_type_and_bookmark_id ON public.bookmark_stats USING btree (date_id, date_type, bookmark_id);


--
-- Name: index_bookmark_stats_on_date_id_and_date_type_and_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmark_stats_on_date_id_and_date_type_and_score ON public.bookmark_stats USING btree (date_id DESC, date_type DESC, score DESC);


--
-- Name: index_bookmarks_on_cached_tag_with_aliases_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_cached_tag_with_aliases_ids ON public.bookmarks USING gin (cached_tag_with_aliases_ids);


--
-- Name: index_bookmarks_on_ref_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_ref_id ON public.bookmarks USING btree (ref_id);


--
-- Name: index_bookmarks_on_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_score ON public.bookmarks USING btree (score DESC);


--
-- Name: index_bookmarks_on_smart_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_smart_score ON public.bookmarks USING btree (smart_score DESC);


--
-- Name: index_bookmarks_on_url_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bookmarks_on_url_and_user_id ON public.bookmarks USING btree (url, user_id);


--
-- Name: index_bookmarks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_user_id ON public.bookmarks USING btree (user_id);


--
-- Name: index_clicks_on_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clicks_on_bookmark_id ON public.clicks USING btree (bookmark_id);


--
-- Name: index_clicks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clicks_on_user_id ON public.clicks USING btree (user_id);


--
-- Name: index_clicks_on_user_id_and_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clicks_on_user_id_and_bookmark_id ON public.clicks USING btree (user_id, bookmark_id);


--
-- Name: index_comments_on_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_bookmark_id ON public.comments USING btree (bookmark_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_follows_on_user_id_and_following_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_follows_on_user_id_and_following_user_id ON public.follows USING btree (user_id, following_user_id);


--
-- Name: index_likes_on_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_bookmark_id ON public.likes USING btree (bookmark_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);


--
-- Name: index_likes_on_user_id_and_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_likes_on_user_id_and_bookmark_id ON public.likes USING btree (user_id, bookmark_id);


--
-- Name: index_notifications_on_params; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_params ON public.notifications USING btree (params);


--
-- Name: index_notifications_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_type_and_recipient_id ON public.notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_tag_subscriptions_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_subscriptions_on_tag_id ON public.tag_subscriptions USING btree (tag_id);


--
-- Name: index_tag_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_subscriptions_on_user_id ON public.tag_subscriptions USING btree (user_id);


--
-- Name: index_tag_subscriptions_on_user_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tag_subscriptions_on_user_id_and_tag_id ON public.tag_subscriptions USING btree (user_id, tag_id);


--
-- Name: index_taggings_on_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_bookmark_id ON public.taggings USING btree (bookmark_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_tag_id_and_bookmark_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_taggings_on_tag_id_and_bookmark_id ON public.taggings USING btree (tag_id, bookmark_id);


--
-- Name: index_taggings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_user_id ON public.taggings USING btree (user_id);


--
-- Name: index_tags_on_bookmarks_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_bookmarks_count ON public.tags USING btree (bookmarks_count DESC);


--
-- Name: index_tags_on_subscriptions_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_subscriptions_count ON public.tags USING btree (subscriptions_count DESC);


--
-- Name: index_tags_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_user_id ON public.tags USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_email_lower_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email_lower_unique ON public.users USING btree (lower((email)::text));


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_remember_token ON public.users USING btree (remember_token);


--
-- Name: index_users_on_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_score ON public.users USING btree (score DESC);


--
-- Name: index_users_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_updated_at ON public.users USING btree (updated_at DESC);


--
-- Name: notifications_idx_0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_idx_0 ON public.notifications USING btree (recipient_type DESC, recipient_id DESC, read_at DESC, created_at DESC);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200729052401'),
('20200801090445'),
('20200802145934'),
('20200806071449'),
('20200809092107'),
('20200809104532'),
('20200809145442'),
('20200811085253'),
('20200811093934'),
('20200812095734'),
('20200812170632'),
('20200813201905'),
('20200814113139'),
('20200815190612'),
('20200816073156'),
('20200816095432'),
('20200816114948'),
('20200818185211'),
('20200825073737'),
('20200830015612'),
('20200830015625'),
('20200831233455'),
('20200902043615'),
('20200902233139'),
('20200904050621'),
('20200904102721'),
('20200904200608'),
('20200908133408'),
('20200909084519'),
('20200909104055'),
('20200911090207'),
('20200912122912'),
('20200912175453'),
('20200913050836'),
('20200913051111'),
('20200913101207'),
('20200915072409'),
('20200916065305'),
('20200916065824'),
('20200917081924'),
('20200917131007'),
('20200918081447'),
('20200918124007'),
('20200919040123'),
('20200919062959'),
('20200919063317'),
('20200922060346'),
('20200924120624'),
('20200926084820'),
('20200926140955'),
('20200927080653'),
('20200927145907'),
('20200927152340'),
('20200928161133'),
('20200929203628'),
('20200930090041'),
('20200930135043'),
('20201002114935'),
('20201010110915'),
('20201010113850'),
('20201012190758'),
('20201019145723'),
('20201019155740'),
('20201019214125'),
('20201021115854'),
('20201023130653'),
('20201023130910'),
('20201031005219'),
('20201115035517'),
('20201216235411'),
('20201228134656');


