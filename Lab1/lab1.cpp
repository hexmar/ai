#include "stdafx.h"
#include <stdlib.h>
#include <conio.h>

const unsigned __int8 typesTable[3][3] = { {2,3,2}, {3,4,3}, {2,3,2} };
const char stateBegin[3][3] = { { '6','2','8' },{ '4','1','7' },{ '5','3','0' } };
const char stateEnd[3][3] = { { '0','1','2' },{ '3','4','5' },{ '6','7','8' } };
const unsigned int OUTCOL = 16;

struct Node;

struct NodeStack {
	struct StackNode {
		StackNode *next;
		Node *ptr;
		StackNode(Node *p, StackNode *n) : next(n), ptr(p) {};
	} *stack;
	NodeStack() : stack(nullptr) {};
	void push(Node *ptr) {
		stack = new StackNode(ptr, stack);
	};
	~NodeStack() {
		StackNode *tmp;
		while (stack != nullptr)
		{
			tmp = stack;
			stack = stack->next;
			delete tmp;
		}
	};
	Node *pop() {
		if (stack != nullptr) {
			Node *ret(stack->ptr);
			StackNode *tmp(stack);
			stack = stack->next;
			delete tmp;
			return ret;
		}
		else
			return nullptr;
	};
	bool notEmpty() {
		if (stack == nullptr)
			return false;
		else
			return true;
	};
	void print(unsigned int count);
} st;

struct NodeQueue {
	struct QueueNode {
		QueueNode *next, *prev;
		Node *ptr;
		QueueNode(Node *pt, QueueNode *n, QueueNode *p) : next(n), prev(p), ptr(pt) {};
	} *start, *end;
	NodeQueue() : start(nullptr), end(nullptr) {};
	void push(Node *ptr) {
		if (start == nullptr)
			start = end = new QueueNode(ptr, nullptr, nullptr);
		else
			start = start->prev = new QueueNode(ptr, start, nullptr);
	};
	Node *pull() {
		if (start != nullptr) {
			Node *ret(end->ptr);
			QueueNode *tmp(end);
			if (start == end)
				end = start = nullptr;
			else {
				end = end->prev;
				end->next = nullptr;
			}
			delete tmp;
			return ret;
		}
		else
			return nullptr;
	};
	bool notEmpty() {
		if (start == nullptr)
			return false;
		else
			return true;
	};
	void print(unsigned int count);
} que;

struct Node {
	static Node *allNodes;
	static unsigned int count;
	char state[3][3]; //Состояние поля.
	unsigned __int8 type; //Тип положения пустой клетки. Кол-во дочерних узлов.
	unsigned int level;
	Node **child, *parent, *nextNode;
	Node *nextToDesired;

	Node(char* state, Node *parent) {
		for (unsigned __int8 i(0); i < 3; i++)
			for (unsigned __int8 j(0); j < 3; j++) {
				this->state[i][j] = state[3 * i + j];
				if (state[3 * i + j] == '0')
					type = typesTable[i][j];
			}
		child = new Node*[type];
		this->parent = parent;
		if (parent != nullptr)
			level = parent->level + 1;
		else
			level = 0;
		nextNode = allNodes;
		allNodes = this;
		nextToDesired = nullptr;
		count++;
	};
	bool operator==(const Node& b) { //Сравнение на совпадение с узлом.
		bool ident(true);
		for (unsigned __int8 i(0); ident && (i < 3); i++)
			for (unsigned __int8 j(0); ident && (j < 3); j++)
				if (state[i][j] != b.state[i][j]) ident = false;
		return ident;
	};
	bool operator==(char *newState) { //Сравнение на совпадение с массивом символов.
		bool ident(true);
		for (unsigned __int8 i(0); ident && (i < 3); i++)
			for (unsigned __int8 j(0); ident && (j < 3); j++)
				if (state[i][j] != newState[3 * i + j]) ident = false;
		return ident;
	};
	static bool isNotExist(char *newState) {
		Node *iterator(allNodes);
		bool notExist(true);
		while (notExist && (iterator != nullptr)) {
			if ((*iterator) == newState) notExist = false;
			iterator = iterator->nextNode;
		}
		return notExist;
	};
	bool search(char *end, bool type) {
		if (operator==(end)) return true; //Проверка на искомое состояние
		char newState[3][3], tmp;
		unsigned __int8 col, row, i(0);
		Node *ret;
		stateOut((char*)newState);
		{
			bool find(true);
			for (unsigned __int8 r(0); find && (r < 3); r++) //Нахождение положения 0.
				for (unsigned __int8 c(0); find && (c < 3); c++)
					if (newState[r][c] == '0') {
						col = c;
						row = r;
						find = false;
					}
		}
		if (col < 2) { //Проверка на сдвиг вправо
			tmp = newState[row][col + 1];
			newState[row][col + 1] = newState[row][col];
			newState[row][col] = tmp;
			if (isNotExist((char*)newState)) {
				child[i] = new Node((char*)newState, this);
				if (type)
					que.push(child[i++]);
				else
					st.push(child[i++]);
			}
			else
				child[i++] = nullptr;
			tmp = newState[row][col + 1];
			newState[row][col + 1] = newState[row][col];
			newState[row][col] = tmp;
		}
		if (row < 2) { //Проверка на сдвиг вниз
			tmp = newState[row + 1][col];
			newState[row + 1][col] = newState[row][col];
			newState[row][col] = tmp;
			if (isNotExist((char*)newState)) {
				child[i] = new Node((char*)newState, this);
				if (type)
					que.push(child[i++]);
				else
					st.push(child[i++]);
			}
			else
				child[i++] = nullptr;
			tmp = newState[row + 1][col];
			newState[row + 1][col] = newState[row][col];
			newState[row][col] = tmp;
		}
		if (col > 0) { //Проверка на сдвиг влево
			tmp = newState[row][col - 1];
			newState[row][col - 1] = newState[row][col];
			newState[row][col] = tmp;
			if (isNotExist((char*)newState)) {
				child[i] = new Node((char*)newState, this);
				if (type)
					que.push(child[i++]);
				else
					st.push(child[i++]);
			}
			else
				child[i++] = nullptr;
			tmp = newState[row][col - 1];
			newState[row][col - 1] = newState[row][col];
			newState[row][col] = tmp;
		}
		if (row > 0) { //Проверка на сдвиг вверх
			tmp = newState[row - 1][col];
			newState[row - 1][col] = newState[row][col];
			newState[row][col] = tmp;
			if (isNotExist((char*)newState)) {
				child[i] = new Node((char*)newState, this);
				if (type)
					que.push(child[i++]);
				else
					st.push(child[i++]);
			}
			else
				child[i++] = nullptr;
		}
		return false;
	};
	void stateOut(char *out) {
		for (unsigned __int8 i(0); i < 3; i++)
			for (unsigned __int8 j(0); j < 3; j++)
				out[3 * i + j] = state[i][j];
	};
	void printSolution() { //Вывести решение nextToDesired
		Node *iter[OUTCOL];
		iter[0] = this;
		while (iter[0] != nullptr) {
			for (unsigned int i(1); i < OUTCOL; i++)
				if (iter[i - 1] != nullptr)
					iter[i] = iter[i - 1]->nextToDesired;
				else
					iter[i] = nullptr;
			for (unsigned int r(0); r < 3; r++) {
				for (unsigned int i(0); i < OUTCOL && (iter[i] != nullptr); i++)
					printf_s("%c %c %c  ", iter[i]->state[r][0], iter[i]->state[r][1], iter[i]->state[r][2]);
				putchar('\n');
			}
			putchar('\n');
			if (iter[OUTCOL - 1] != nullptr)
				iter[0] = iter[OUTCOL - 1]->nextToDesired;
			else
				iter[0] = nullptr;
		}
	};
	void saveSolution() {
		FILE *f;
		fopen_s(&f, "output.txt", "w");
		Node *iter(this);
		while (iter != nullptr)
		{
			fprintf_s(f, "%c %c %c\n%c %c %c\n%c %c %c\n\n",
				iter->state[0][0], iter->state[0][1], iter->state[0][2],
				iter->state[1][0], iter->state[1][1], iter->state[1][2],
				iter->state[2][0], iter->state[2][1], iter->state[2][2]);
			iter = iter->nextToDesired;
		}
		fclose(f);
	};
	void print() {
		unsigned int i, j;
		for (i = 0; i < 3; i++) {
			printf_s("%c %c %c     ", state[i][0], state[i][1], state[i][2]);
			for (j = 0; j < type; j++)
				if (child[j] != nullptr)
					printf_s("%c %c %c  ", child[j]->state[i][0], child[j]->state[i][1], child[j]->state[i][2]);
			putchar('\n');
		}
		putchar('\n');
	};
};

void NodeStack::print(unsigned int count) {
	unsigned int i;
	StackNode *iter(stack);
	for (i = 0; i < count && iter != nullptr; i++, iter = iter->next) {
		printf_s("%c %c %c\n%c %c %c\n%c %c %c\n\n",
			iter->ptr->state[0][0], iter->ptr->state[0][1], iter->ptr->state[0][2],
			iter->ptr->state[1][0], iter->ptr->state[1][1], iter->ptr->state[1][2],
			iter->ptr->state[2][0], iter->ptr->state[2][1], iter->ptr->state[2][2]);
	}
};
void NodeQueue::print(unsigned int count) {
	unsigned int i;
	QueueNode *iter(end);
	for (i = 0; i < count && iter != nullptr; i++, iter = iter->prev) {
		printf_s("%c %c %c\n%c %c %c\n%c %c %c\n\n",
			iter->ptr->state[0][0], iter->ptr->state[0][1], iter->ptr->state[0][2],
			iter->ptr->state[1][0], iter->ptr->state[1][1], iter->ptr->state[1][2],
			iter->ptr->state[2][0], iter->ptr->state[2][1], iter->ptr->state[2][2]);
	}
};
Node *Node::allNodes = nullptr;
unsigned int Node::count = 0;

int main() {
	printf_s("Input type of search (1-Depth-First, 2-Uniform-Cost): ");
	char c;
	scanf_s("%c", &c, 1);
	bool type = false, runType = false;
	if (c == '2') type = true;
	printf_s("Input type of running (1-Step-by-Step, 2-Run): ");
	scanf_s("%c", &c, 1); scanf_s("%c", &c, 1);
	if (c == '1') runType = true; scanf_s("%c", &c, 1);
	Node begin((char*)stateBegin, nullptr);
	Node *ret;
	unsigned int opens(1), prCount(0);
	bool cont = !begin.search((char*)stateEnd, type);
	system("cls");
	printf_s("Nodes\tOpens\n%d\t%d", Node::count, opens);
	if (runType) {
		printf_s("\n\nLevel %d\n\n", 0);
		begin.print();
		printf_s("Next states\n\n");
		if (type)
			que.print(4);
		else
			st.print(4);
		printf_s("Space - next step; R - continue.");
		do {
			c = _getch();
			if (c == 'r') {
				runType = false;
				system("cls");
				printf_s("Nodes\tOpens\n");
			}
		} while (c != ' ' && c != 'r');
	}
	while ((st.notEmpty() || que.notEmpty()) && cont) {
		if (type)
			ret = que.pull();
		else
			ret = st.pop();
		cont = !ret->search((char*)stateEnd, type);
		opens++;
		if (Node::count - prCount > 1000) {
			if (!runType)
				printf("\r%d\t%d", Node::count, opens);
			prCount += 1000;
		}
		if (runType) {
			system("cls");
			printf_s("Nodes\tOpens\n%d\t%d\n\nLevel %d\n\n", Node::count, opens, ret->level);
			ret->print();
			printf_s("Next states\n\n");
			if (type)
				que.print(4);
			else
				st.print(4);
			printf_s("Space - next step; R - continue.");
			do {
				c = _getch();
				if (c == 'r') {
					runType = false;
					system("cls");
					printf_s("Nodes\tOpens\n");
				}
			} while (c != ' ' && c != 'r');
		}
	}
	while (ret != (&begin)) {
		ret->parent->nextToDesired = ret;
		ret = ret->parent;
	}
	system("cls");
	printf_s("Nodes\tOpens\n%d\t%d\n\n", Node::count, opens);
	begin.printSolution();
	system("pause");
	return 0;
}