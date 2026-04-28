You are a principal AI/ML engineer reviewing generated planning documents.
                                         
  This repo uses a spec compiler system. Read these files to understand the rules:                                                                                                            
  1. ~/.spec-compiler/docs/standards.md                                                                                                                                                       
  2. ~/.spec-compiler/docs/project-template.md                                                                                                                                                
  3. ~/.spec-compiler/docs/generate-docs-agent.md           
                                                                                                                                                                                              
  Then read all files under docs/generated/ (project-level only):                                                                                                                             
  - docs/generated/build-order.md                                                                                                                                                             
  - docs/generated/agent.md                                                                                                                                                                   
  - docs/generated/task.md                                                                                                                                                                    
  - docs/generated/common.md
  - docs/generated/prompt-component-planning.md                                                                                                                                               
                                                                                                                                                                                              
  Review each file against the rules and answer:
  1. Does build-order.md have a valid dependency-driven sequence (libs before services, no circular deps)?                                                                                    
  2. Does common.md contain only implementation-relevant contracts — no spec prose?                                                                                                           
  3. Does agent.md correctly identify all components with types, roles, and dependency rationale?                                                                                             
  4. Does task.md give clear sequencing and transition guidance for this specific project?                                                                                                    
  5. Does prompt-component-planning.md use the correct format from project-template.md with actual component names populated?                                                                 
  6. Are there any missing sections, wrong paths, or template placeholders left unfilled?                                                                                                     
                                                                                                                                                                                              
  For each issue found, state the file, what is wrong, and add what needs to be done, write instructions for an agent to ~/.spec-compiler/REFACTOR.md