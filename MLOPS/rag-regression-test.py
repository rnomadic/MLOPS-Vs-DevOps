import pytest
import time
from my_rag_app import MyRAGSystem # Import your actual RAG class
# Define your performance budgets (in seconds)
MAX_RETRIEVAL_LATENCY = 0.5 
MAX_TOTAL_LATENCY = 3.0

@pytest.fixture
def rag_system():
    return MyRAGSystem()

def test_retrieval_accuracy(rag_system):
    query = "What is the policy on remote work?"
    expected_doc_id = "DOC_12345"
    
    # 1. Get retrieved chunks/documents
    retrieved_docs = rag_system.retriever.get_relevant_documents(query)
    
    # 2. Extract IDs from results
    retrieved_ids = [doc.metadata['id'] for doc in retrieved_docs]
    
    # 3. Assert the correct doc is in the top 3 results
    assert expected_doc_id in retrieved_ids[:3], f"Failed to retrieve {expected_doc_id} for query: {query}"


def test_rag_latency_performance(rag_system):
    query = "Standard hello world query"
    
    start_time = time.perf_counter()
    
    # Measure Retrieval specifically
    retr_start = time.perf_counter()
    docs = rag_system.retriever.get_relevant_documents(query)
    retr_duration = time.perf_counter() - retr_start
    
    # Measure End-to-End
    response = rag_system.query(query)
    total_duration = time.perf_counter() - start_time
    
    # Assertions
    assert retr_duration < MAX_RETRIEVAL_LATENCY, f"Retrieval too slow: {retr_duration:.2f}s"
    assert total_duration < MAX_TOTAL_LATENCY, f"Total RAG pipeline too slow: {total_duration:.2f}s"