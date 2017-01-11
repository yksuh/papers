#include <stdio.h>    /* standard in and output*/
#include <sys/socket.h> /* for socket() and socket functions*/
#include <arpa/inet.h>  /* for sockaddr_in and inet_ntoa() */
#include <stdlib.h>   
#include <string.h>    
#include <unistd.h>     /* for close() */
#include <time.h> 
#include <limits.h> 

#define PORT_NUM 2400
#define COEF 1460000000 // 16B
#define MAX_INCR 420000000
#define MAX_ITER 40
int first_half[MAX_ITER];
int second_half[MAX_ITER];
char c;
int f_iter = 0, s_iter=0;
struct timeval tim;
FILE* f_half = NULL;
FILE* s_half = NULL;
double t1=0, t2=0;
#if 1 
inline void foo(int exp_secs) {
	unsigned long long i, j, x;
	//printf("Increment work of %d seconds starts!\n", exp_secs);
	//max = 2147483647;
	//max = 2000000000; 
	unsigned long long fn = (long)COEF*(long)exp_secs;
	//printf("max iterations: %llu\n", n);
	// first half
	gettimeofday(&tim, NULL);
	t1=tim.tv_sec*1000+(tim.tv_usec/1000.0);
	for (i = 1; i <= fn/2; i++) {
		x = 0;
		for (j = 0; j < UINT_MAX; j++) {
			x++;
		}
	}
	gettimeofday(&tim, NULL);
	t2=tim.tv_sec*1000+(tim.tv_usec/1000.0);
	first_half[f_iter++] = (int)(t2-t1);
	// second half
	gettimeofday(&tim, NULL);
	t1=tim.tv_sec*1000+(tim.tv_usec/1000.0);
	for (i = 1; i <= fn/2; i++) {
                x = 0;
                for (j = 0; j < UINT_MAX; j++) {
                        x++;
                }
        }
	gettimeofday(&tim, NULL);
        t2=tim.tv_sec*1000+(tim.tv_usec/1000.0);
        second_half[s_iter++] = (int)(t2-t1);
	//sleep(exp_secs);
	//printf("Done!\n");
}
#else
inline void foo(int exp_secs) {
        unsigned long long i, j,k, x;
        for (i = 1; i <= (long)exp_secs; i++) {
                x = 0;
                for (j = 0; j < MAX_INCR; j++) {
                        x++;
                }
        }
}
#endif

void reply(char c, int connected){
//	printf("Response signal has been sent! : %d on %c\n\n", success, c);
	if (send(connected, "1", 1, 0) == -1) {
		perror("send() failed");
	}
//	printf("Response signal has been sent! : %d on %c\n\n", success, c);
//	success = 0;
	close (connected);
}

int main(int argc, char *argv[]) {
	int exp_run_time = 0;
	int total_size = sizeof(int);

	int sock, connected, bytes_received, true = 1;
	struct sockaddr_in server_addr, client_addr;
	int sin_size;
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
//		if ((sock = socket(AF_LOCAL, SOCK_STREAM, 0)) == -1) {
		perror("Socket");
		exit(1);
	}
printf("command socket : %d\n", sock);
	
	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &true, sizeof(int)) == -1) {
		perror("Setsockopt");
		exit(1);
	}

	server_addr.sin_family = AF_INET;
//		server_addr.sin_family = AF_LOCAL;
	server_addr.sin_port = htons(PORT_NUM);
	server_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(server_addr.sin_zero), 8);

	if (bind(sock, (struct sockaddr *) &server_addr, sizeof(server_addr))
			== -1) {
		perror("Unable to bind");//Unable to bind: Address already in use
		exit(1);
	}

	if (listen(sock, 5) == -1) {
		perror("Listen");
		exit(1);
	}

	/***
	 * Data Socket
	 */
	int data_sock, data_connected, data_true = 1;
	struct sockaddr_in data_server_addr, data_client_addr;
	if ((data_sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		perror("Data Socket Error");
		exit(1);
	}
printf("data socket : %d\n", data_sock);
	if (setsockopt(data_sock, SOL_SOCKET, SO_REUSEADDR, &true, sizeof(int)) == -1) {
		perror("Setsockopt");
		exit(1);
	}

	int dataPortNum = PORT_NUM+1;
	data_server_addr.sin_family = AF_INET;
	data_server_addr.sin_port = htons(dataPortNum);
	data_server_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(data_server_addr.sin_zero), 8);

	if (bind(data_sock, (struct sockaddr *) &data_server_addr, sizeof(data_server_addr))
			== -1) {
		printf("cannot bind\n");
		perror("Unable to bind");//Unable to bind: Address already in use
		exit(1);
	}

	if (listen(data_sock, 5) == -1) {
		perror("Listen");
		exit(1);
	}
			
	//printf("\nTCPServer Waiting for client on port 2400");
	char c;
	while (1) { // until receiving signal 'k' 
		sin_size = sizeof(client_addr);
//			puts("\nWaiting for incoming connections...");
		connected = accept(sock, (struct sockaddr *) &client_addr,
				(socklen_t*) &sin_size);
		if (connected < 0) {
			perror("accepted failed");
		}

		if((bytes_received = read(connected, &c, 1)) > 0){
			if (c == 'd') { // ready to receive a list for fooing
				// send reply signal
				reply(c, connected);
				
				printf("OK, I am ready to receive!\n");
				
				puts("\nWaiting for incoming data connections...");
				int data_sin_size = sizeof(data_client_addr);
				data_connected = accept(data_sock, (struct sockaddr *) &data_client_addr,
						(socklen_t*) &data_sin_size);
				if (data_connected < 0) {
					perror("data socket accept failed");
				}
				
				printf("ready to receive data ...  %d\n", total_size);
				
				int data_bytes_received = 0;
				int sum_recv_bytes = 0;
				int offset = 0;
				do{
					int size = 4;
					char c[size];
					if((data_bytes_received=read(data_connected, c, size)) > 0){
						sum_recv_bytes += data_bytes_received;
						exp_run_time = *(int*)c;
					}
				}while(sum_recv_bytes < total_size);
				printf("\n done with receipt ... : %d\n", exp_run_time);

				// sett data file names
				char* str1 = "dual1_PUT";
				char* str2 = "dual2_PUT";
				char* suffix = ".dat";
				char f_half_file_name[100];
				char s_half_file_name[100];
				// first half
				sprintf(f_half_file_name, "%s%d%s", str1, exp_run_time, suffix);
				f_half = fopen(f_half_file_name, "w");
				// second half
				sprintf(s_half_file_name, "%s%d%s", str2, exp_run_time, suffix);
				s_half = fopen(s_half_file_name, "w");
				reply('1', data_connected);
				continue;
			}
			else if (c == 's') { // start fooing	
				//printf("foo start\n");
				//struct timeval tim;
				//gettimeofday(&tim, NULL);
				//double t1=tim.tv_sec*1000+(tim.tv_usec/1000.0);
				//clock_t cpu_start = clock();
				foo(exp_run_time);
				//clock_t cpu_end = clock();
				//double cpu_temp = (double)(cpu_end-cpu_start) / CLOCKS_PER_SEC;
				//fprintf(stdout, "Total CPU time on read requests: '%.4f(sec)'\n", cpu_temp);
				//gettimeofday(&tim, NULL);
				//double t2=tim.tv_sec*1000+(tim.tv_usec/1000.0);
				//printf("%.6lf msecs elapsed\n", t2-t1);
			}
			// send reply signal
			reply(c, connected);	
			/****
			 * Post-processing 
			 */
			if (c == 'k'){ // if signal is 'k', then program is over!
				// first half
				int j = 0;
				fprintf(f_half, "ITERNUM\tMETIME\n", first_half[j]);
				t2=tim.tv_sec*1000+(tim.tv_usec/1000.0);
				for(j=0;j<MAX_ITER;j++){
					fprintf(f_half, "%d\t%d\n", j+1, first_half[j]);
				}
				fclose(f_half);
				// second half
				fprintf(s_half, "ITERNUM\tMETIME\n", second_half[j]);
				for(j=0;j<MAX_ITER;j++){
					fprintf(s_half, "%d\t%d\n", j+1, second_half[j]);
				}
				fclose(s_half);
				break;
			}
		}
	}
//		printf("Program normally exits!:%c\n",c);	
	return 0;
}

