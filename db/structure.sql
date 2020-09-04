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
    score integer GENERATED ALWAYS AS ((dups_count + likes_count)) STORED
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
    score integer GENERATED ALWAYS AS ((dups_count + likes_count)) STORED,
    smart_score double precision GENERATED ALWAYS AS (((log((((likes_count + dups_count))::numeric + 1.1)))::double precision + (date_part('epoch'::text, (created_at - '2020-08-10 00:00:00'::timestamp without time zone)) / (4500)::double precision))) STORED,
    comments_count integer DEFAULT 0,
    tags_count integer DEFAULT 0,
    content text,
    cached_tag_names character varying,
    cached_tag_ids bigint[] DEFAULT '{}'::bigint[],
    tsv tsvector GENERATED ALWAYS AS ((((setweight(to_tsvector('simple'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (COALESCE(cached_tag_names, ''::character varying))::text), 'A'::"char")) || setweight(to_tsvector('simple'::regconfig, COALESCE(description, ''::text)), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, COALESCE(content, ''::text)), 'D'::"char"))) STORED
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


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
    bookmarks_count integer DEFAULT 0
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
    admin boolean DEFAULT false
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
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


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
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


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
-- Name: fulltext_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_idx ON public.bookmarks USING gin (tsv);


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
('20200904200608');


