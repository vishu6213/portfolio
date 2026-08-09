import { LoadingBreadcrumb } from './animated-loading-svg-text-shimmer';
import { Button } from './button';
import { Moon, Sun } from 'lucide-react';

export default function App() {
  return (
    <div className="flex min-h-screen items-center justify-center font-sans p-8">
      {/* Theme Toggle */}
      <div className="fixed top-4 right-4">
        <Button
          variant="outline"
          size="icon"
        >
          <Sun className="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
          <span className="sr-only">Toggle theme</span>
        </Button>
      </div>

      <LoadingBreadcrumb />
    </div>
  );
}
