
use std::collections::HashMap;
use std::hash::Hash;

#[derive(Debug, Clone, PartialEq)]
struct File {
    name: String,
    size: usize,
    file_type: String,
    hash: String,
}

struct FileManager {
    files: HashMap<String, Vec<File>>,
}

impl FileManager {
    fn new() -> FileManager {
        FileManager {
            files: HashMap::new(),
        }
    }

    fn add_file(&mut self, file: File) {
        let key = file.name.clone();
        self.files.entry(key).or_insert(vec![]).push(file);
    }

    fn delete_file(&mut self, file_name: &str) -> bool {
        self.files.remove(file_name).is_some()
    }

    fn retrieve_file(&self, file_name: &str) -> Option<&Vec<File>> {
        self.files.get(file_name)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add_and_retrieve_file() {
        let mut manager = FileManager::new();
        let file = File {
            name: "test.txt".to_string(),
            size: 1024,
            file_type: "txt".to_string(),
            hash: "abc123".to_string(),
        };
        manager.add_file(file.clone());
        assert_eq!(manager.retrieve_file("test.txt").unwrap()[0], file);
    }

    #[test]
    fn test_delete_file() {
        let mut manager = FileManager::new();
        let file = File {
            name: "test.txt".to_string(),
            size: 1024,
            file_type: "txt".to_string(),
            hash: "abc123".to_string(),
        };
        manager.add_file(file);
        assert!(manager.delete_file("test.txt"));
        assert!(manager.retrieve_file("test.txt").is_none());
    }
}
