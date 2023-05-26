#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>
#define GENE 8
#define MAX 100

typedef struct gene {
	int x[8];
} Gene;

FILE* file;

void init_value_generator(unsigned int init_val, Gene *node) {
	//init_val에 해당하는 값 설정
	for (int index = 0; index < GENE; index++) {
		node->x[index] = init_val & (unsigned int)pow(2, index) ? 1 : 0;
	}
}

/*
t-1과 t를 비교해서 같은지 검사
반환: 0(다름), 1(같음)
*/
int fixed_ponit_checker(Gene* state, Gene* current, unsigned int init_val) {
	static counter = 0;
	Gene fixed_points;
	int flag;
	int i;
	for (i = 0, flag = 0; flag == 0 && i < 8; i++) {
		if (state->x[i] != current->x[i]) {
			flag++;
		}
	}
	if (flag == 0) {
		printf(" ---> fixed point 발견!!\n\n");

		fixed_points = *current;
		fprintf(file, "%d,", counter);
		fprintf(file, "%d,", init_val);
		for (int i = GENE - 1; i >= 0; i--)
			fprintf(file, "%d", fixed_points.x[i]);
		fprintf(file, "\n");

		counter++;

		printf("<fixed point>\n");
		for (int i = GENE - 1; i >= 0; i--)
			printf("%2d", fixed_points.x[i]);
		printf("\n");
		printf("\n\n");

		return 1;
	} else {
		printf("\n");
		return 0;
	}
}

/*
사이클 생성 검사
반환: 0(), 1(사이클 생성)
*/
int cycle_checker(Gene* state[], int time) {
	int flag = 0;
	int i;
	int current;
	int deep = time - 3;
	if (deep < 0)
		return 0;
	for (current = time - 2; current > deep; current--) {
		for (flag = 0, i = 0; flag == 0, i < 8; i++)
			if (state[time]->x[i] != state[current]->x[i])
				flag++;
		if (flag == 0)
			break;
	}
	if (flag == 0) {
		printf("t=(%d, %d) cycle 발생\n", current, time);
		return 1;
	}
	else
		return 0;
}

int main() {
	int time;
	if (0 != fopen_s(&file, "fixed_point.csv", "w")) {
		printf("파일 열기 실패\n");
		exit(-2);
	}
	fputs("num,init_val,val\n", file);
	Gene* node[MAX];
	if (node == NULL) {
		printf("node 할당 실패\n");
		exit(-1);
	}
	node[0] = (Gene*)malloc(sizeof(Gene));
	if (node[0] == NULL) {
		printf("node[%d] 할당 실패\n", 0);
		exit(-1);
	}


	for (int init_val = 0; init_val < 256; init_val++) {
		init_value_generator(init_val, node[0]);

		//초기값 출력
		printf(" init=%3d :", init_val);
		for (int i = GENE - 1; i >= 0; i--)
			printf("%2d", node[0]->x[i]);
		printf("\n");

		//네트워크 구현
		time = 0;
		do {
			if (time >= MAX-1) {
				printf("시뮬레이션 %d 초과\n", MAX);
				break;
			}
			time++;
			node[time] = (Gene*)malloc(sizeof(Gene));
			if (node[time] == NULL) {
				printf("node[%d] 할당 실패\n", time);
				exit(-1);
			}

			node[time]->x[0] = !node[time - 1]->x[2] && node[time - 1]->x[6] && !node[time - 1]->x[7];
			node[time]->x[1] = (node[time - 1]->x[4] || node[time - 1]->x[5]) && !node[time - 1]->x[7];
			node[time]->x[2] = node[time - 1]->x[7];
			node[time]->x[3] = node[time - 1]->x[1] && !node[time - 1]->x[6];
			node[time]->x[4] = node[time - 1]->x[1] || node[time - 1]->x[3];
			node[time]->x[5] = node[time - 1]->x[2] && !node[time - 1]->x[7];
			node[time]->x[6] = node[time - 1]->x[1] && !node[time - 1]->x[7];
			node[time]->x[7] = !(node[time - 1]->x[0] || node[time - 1]->x[1]) && (node[time - 1]->x[3] || node[time - 1]->x[6]);

			printf("     [%3d] ", time);
			for (int i = GENE - 1; i >= 0; i--)
				printf("%2d", node[time]->x[i]);
		} while (!fixed_ponit_checker(node[time - 1], node[time], init_val) && !cycle_checker(node, time));

		for (int i = 1; i <= time; i++) {
			free(node[i]);
			node[i] = NULL;
		}
	}
	fclose(file);
	return 0;
}