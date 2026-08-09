export const projects = [
  {
    id: "neurobase",
    title: "Neurobase",
    category: "Web3 AI Agent",
    shortDescription: "An agentic AI crypto companion that lets you swap, analyze, and send tokens securely via simple chat conversations.",
    tags: ["React", "AI Agents", "Solidity", "Web3"],
    image: "/images/neurobase.png",
    caseStudy: {
      overview: "Neurobase is an advanced AI agentic crypto assistant designed to simplify decentralized finance interactions. By integrating natural language processing with Web3 protocols, it allows users to execute complex blockchain actions—like token swaps, asset transfers, and real-time market analysis—directly through a conversational chat interface.",
      challenge: "Blockchain interfaces are notoriously complex, requiring users to navigate multiple wallets, gas fees, and DEX aggregators. For beginners, sending or swapping tokens carries high anxiety and risks of manual error.",
      approach: "We developed an LLM-powered agentic system that translates conversational prompts into secure, verified Web3 transactions. Built on top of robust smart contract routers, the system performs pre-flight simulation and safety checks before asking the user for final signature confirmation.",
      solution: "An interactive React frontend backed by an AI coordination layer that parses user intents. If a user chats 'Swap 0.1 ETH to USDC', the agent fetches optimal routes via DEX APIs, builds the transaction payload, and prompts the wallet for approval.",
      technologies: ["React", "AI Agents", "Solidity", "Ethers.js", "Node.js"],
      outcome: "A frictionless Web3 onboarding experience that reduces swap times by 60% and eliminates transaction configuration errors, making crypto accessible via everyday language."
    }
  },
  {
    id: "rag",
    title: "RAG System",
    category: "AI Engine",
    shortDescription: "A highly optimized Retrieval-Augmented Generation system for querying complex private documents with zero hallucination.",
    tags: ["Python", "LangChain", "Vector DB", "LLM"],
    image: "/images/rag.png",
    caseStudy: {
      overview: "A state-of-the-art Retrieval-Augmented Generation (RAG) system engineered to ingest, embed, and query massive corporate knowledge bases. It combines advanced semantic search with LLMs to provide context-aware, fully cited answers to user questions while eliminating hallucinated facts.",
      challenge: "Standard LLMs suffer from knowledge cutoff dates and frequently hallucinate incorrect answers when asked about specific, private corporate documents, proprietary codebases, or complex user manuals.",
      approach: "Implemented a multi-stage chunking and indexing pipeline using state-of-the-art text embedding models. Queries are pre-processed to retrieve the most relevant document chunks from a vector database before synthesizing the final response using a context-constrained LLM.",
      solution: "Built a Python-based query middleware leveraging LangChain and Pinecone. The system incorporates hybrid search (combining dense vector embeddings with sparse keyword search) and cross-encoder re-ranking to achieve 95% accuracy in retrieving relevant contexts.",
      technologies: ["Python", "LangChain", "Pinecone", "OpenAI API", "React"],
      outcome: "Reduced document search time for support agents by 80% and successfully deployed a secure, hallucination-free QA system over thousands of internal PDF manuals and guidelines."
    }
  },
  {
    id: "team-task-manager",
    title: "Team Task Manager",
    category: "Web Application",
    shortDescription: "A collaborative real-time project management dashboard featuring Kanban boards, live chat, and workload analytics.",
    tags: ["React", "Next.js", "Firebase", "Realtime"],
    image: "/images/task-manager.png",
    caseStudy: {
      overview: "Team Task Manager is a sleek, real-time project management workspace built to help modern squads collaborate seamlessly. It integrates kanban boards, live chat rooms, calendar views, and automatic workload distribution analysis in a cohesive dashboard.",
      challenge: "Many task managers are cluttered, slow, and lack instant sync. Teams are forced to bounce between separate tools for communication (Slack) and task tracking (Jira), leading to misalignment.",
      approach: "Focused on an ultra-responsive, real-time architecture utilizing reactive data listeners. We designed a clean, grid-based dashboard with drag-and-drop mechanics and embedded instant chat directly inside task cards.",
      solution: "Developed a modular React app powered by Firestore listener pipelines. Included interactive analytics charts showcasing task progress, sprint velocities, and individual team member bandwidth to prevent burnout.",
      technologies: ["React", "Next.js", "Firebase", "Tailwind CSS", "Recharts"],
      outcome: "A beautiful, premium productivity app that boosts team coordination speed, reduces meeting overhead, and provides project managers with instant visibility into sprint status."
    }
  }
];
