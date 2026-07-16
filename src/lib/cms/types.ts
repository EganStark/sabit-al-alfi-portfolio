export type PostStatus = 'draft' | 'published' | 'scheduled';

export interface CmsPost {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  body: string;
  cover_url: string | null;
  cover_alt: string | null;
  tags: string[];
  status: PostStatus;
  featured: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
}

