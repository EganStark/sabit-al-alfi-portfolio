import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const projects = defineCollection({
  loader: glob({ base: './src/content/projects', pattern: '**/*.json' }),
  schema: z.object({
    title: z.string(),
    category: z.enum(['Research', 'Web App', 'Systems']),
    status: z.enum(['Complete', 'In Progress']),
    description: z.string(),
    tags: z.array(z.string()),
    liveUrl: z.url().nullable(),
    githubUrl: z.url().nullable(),
    sourceVisibility: z.enum(['Public', 'Private', 'Unconfirmed']).default('Unconfirmed'),
    featured: z.boolean().default(false),
    order: z.number().int().nonnegative(),
  }),
});

const research = defineCollection({
  loader: glob({ base: './src/content/research', pattern: '**/*.json' }),
  schema: z.object({
    title: z.string(),
    status: z.enum(['Published', 'Accepted']),
    abstract: z.string(),
    link: z.url().nullable(),
    venue: z.string(),
    publisher: z.enum(['IEEE', 'Springer']),
    year: z.number().int(),
    doi: z.string(),
    authorshipLabel: z.enum(['First author', 'Second author', 'Co-author']),
    authorPosition: z.number().int().positive(),
    authorCount: z.number().int().positive(),
    order: z.number().int().nonnegative(),
  }),
});

export const collections = { projects, research };
