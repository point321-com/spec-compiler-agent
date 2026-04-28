You are a principal AI/ML engineer reviewing generated planning documents.

Implement ~/.spec-compiler/REFACTOR.md                                                                                                                                                      
                                                                                                                                                                                              
  Read in this order:    
  1. cREADME.md                                                                                                                                                                     
  2. ~/.spec-compiler/REFACTOR.md                                                                                                                                                             
  3. ~/.spec-compiler/docs/standards.md                                                                                                                                                       
  4. ~/.spec-compiler/docs/project-template.md                                                                                                                                                
  5. ~/.spec-compiler/docs/generate-docs-agent.md                                                                                                                                             
                                                                                                                                                                                              
  Apply every fix listed in REFACTOR.md to the files it targets.                                                                                                                              
  Do not edit anything under docs/generated/.                                                                                                                                                 
  Do not regenerate docs/generated/ files — that is a separate pass.                                                                                                                          
  When done:
  1. summarize what will be changed
  2. wait for confirmation,
  3. implement and confirm which lines were changed in each template file
  4. write ~/.spec-compiler/CHANGELOG.md
  